require 'rails_helper'

RSpec.describe ContentMapper do
  subject do
    Class.new do
      include ContentMapper
    end
  end

  describe '.key' do
    context 'when `from` is nil when defining a key' do
      it 'throws an error' do
        expect { subject.send :key, :foo, from: nil }.to raise_error(
          ArgumentError,
          "[ContentMapper] 'from' needs to be specified and not blank"
        )
      end
    end

    context 'when `from` is an empty Array when defining a key' do
      it 'throws an error' do
        expect { subject.send :key, :foo, from: [] }.to raise_error(
          ArgumentError,
          "[ContentMapper] 'from' needs to be specified and not blank"
        )
      end
    end

    context 'when `from` is a simple value' do
      it 'does not throw an error' do
        expect { subject.send :key, :foo, from: :foo }.not_to raise_error
      end
    end

    context 'when `from` is a non-empty Array' do
      it 'does not throw an error' do
        expect { subject.send :key, :foo, from: [:foo] }.not_to raise_error
      end
    end
  end

  describe '.map_from' do
    context 'key with a simple `from` value' do
      before do
        subject.send :key, :foo, from: 'a'
      end

      it 'should use that value from the provided hash' do
        expect(subject.map_from('a' => 1, 'b' => 2)).to eq foo: 1
      end
    end

    context 'key with an Array `from` with one entry' do
      before do
        subject.send :key, :foo, from: ['a']
      end

      it 'should use that value from the provided hash' do
        expect(subject.map_from('a' => 1, 'b' => 2)).to eq foo: 1
      end
    end

    context 'key with an Array `from` with multiple entries forming a path' do
      before do
        subject.send :key, :foo, from: %i[a aa]
      end

      it 'should pluck out that value from the provided hash' do
        expect(subject.map_from(a: { aa: 1 }, b: 2)).to eq foo: 1
      end
    end

    context 'key with a `mapper` specified' do
      let :mapper_class do
        Class.new do
          include ContentMapper
          key :bar, from: %w[b c]
        end
      end

      before do
        subject.send :key, :foo, from: ['a'], mapper: mapper_class
      end

      context 'when the value from the source hash is an Array' do
        let :source do
          {
            'a' => [
              { 'b' => { 'c' => 1 } },
              { 'b' => { 'c' => 2 } }
            ]
          }
        end

        let :result do
          {
            foo: [
              { bar: 1 },
              { bar: 2 }
            ]
          }
        end

        it 'uses the specified mapper to process the values' do
          expect(subject.map_from(source)).to eq result
        end
      end

      context 'when the value from the source hash is a Hash' do
        let :source do
          { 'a' => { 'b' => { 'c' => 1 } } }
        end

        let :result do
          { foo: { bar: 1 } }
        end

        it 'uses the specified mapper to process the value' do
          expect(subject.map_from(source)).to eq result
        end
      end
    end

    context 'key with `translated` options specified' do
      before do
        allow(LocalesService).to receive(:enabled).and_return(%i[en fr ar yy zz])

        subject.send :key, :foo, from: 'a', translated: { field: 'text' }
      end

      let :source do
        {
          'a' => [
            { 'lang' => 'en', 'text' => 'foo', 'text_rtl' => '' },
            { lang: 'fr', 'text' => 'bar', 'text_rtl' => '' },
            { 'lang' => 'ar', 'text' => '', 'text_rtl' => 'baz' },
            { 'lang' => 'yy', 'text' => nil, 'text_rtl' => '' },
            { 'lang' => 'zz', 'text' => '', 'text_rtl' => '' },
            { 'lang' => 'unneeded', 'text' => 'unneeded', 'text_rtl' => '' }
          ]
        }
      end

      let :result do
        {
          foo_en: 'foo',
          foo_fr: 'bar',
          foo_ar: 'baz',
          foo_yy: nil,
          foo_zz: ''
        }
      end

      it 'pulls out the individual translated values' do
        expect(subject.map_from(source)).to eq result
      end
    end

    context 'key with `is_markdown` set to `true`' do
      before do
        subject.send :key, :foo, from: 'a', is_markdown: true
      end

      let :source do
        {
          'a' => '**foo**'
        }
      end

      let :result do
        {
          foo: "<p><strong>foo</strong></p>\n"
        }
      end

      it 'converts the markdown into HTML' do
        expect(subject.map_from(source)).to eq result
      end
    end

    context 'key with `is_markdown` set to `false`' do
      before do
        subject.send :key, :foo, from: 'a', is_markdown: false
      end

      let :source do
        {
          'a' => '**foo**'
        }
      end

      let :result do
        {
          foo: '**foo**'
        }
      end

      it 'does not perform any markdown conversion' do
        expect(subject.map_from(source)).to eq result
      end
    end

    context 'key with a `default` specified' do
      before do
        subject.send :key, :foo, from: 'a', default: 100
      end

      it 'uses the default value if the value from the source hash is nil' do
        expect(subject.map_from('b' => 1)).to eq foo: 100
      end

      it 'still uses the source value if it\'s not nil' do
        expect(subject.map_from('a' => 1)).to eq foo: 1
      end
    end

    context 'for blank values in the source hash' do
      before do
        subject.send :key, :foo, from: :a
      end

      it 'uses the blank value' do
        expect(subject.map_from({})).to eq foo: nil
        expect(subject.map_from(a: nil)).to eq foo: nil
        expect(subject.map_from(a: '')).to eq foo: ''
      end
    end
  end
end
