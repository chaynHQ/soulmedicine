# Use official Ruby image with appropriate version
FROM ruby:3.1

# Install Linux dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

# Set working directory inside container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock first (for faster builds when no changes)
COPY Gemfile* ./

# Install Ruby gems
RUN bundle install

# Copy the entire project into the container
COPY . .

# Expose Rails server port
EXPOSE 3000

# Default command to run Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
