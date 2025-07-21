'use client';

import { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  TextField,
  Button,
  Alert,
  Checkbox,
  FormControlLabel,
  Link as MuiLink,
} from '@mui/material';
import { signInWithEmailAndPassword, createUserWithEmailAndPassword } from 'firebase/auth';
import { auth } from '@/lib/auth/firebase';
import { useAuth } from '@/hooks/useAuth';

interface SignInProps {
  onSignIn?: () => void;
}

export default function SignIn({ onSignIn }: SignInProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isSignUp, setIsSignUp] = useState(false);
  const [termsAccepted, setTermsAccepted] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  
  const { user } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      if (isSignUp) {
        if (password !== confirmPassword) {
          throw new Error('Passwords do not match');
        }
        if (!termsAccepted) {
          throw new Error('You must accept the terms of service');
        }
        
        // Create new user
        await createUserWithEmailAndPassword(auth, email, password);
      } else {
        // Sign in existing user
        await signInWithEmailAndPassword(auth, email, password);
      }
      
      onSignIn?.();
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  if (user && !user.termsAccepted) {
    return (
      <Card sx={{ maxWidth: 400, mx: 'auto', mt: 4 }}>
        <CardContent>
          <Typography variant="h5" component="h1" gutterBottom>
            Accept Terms of Service
          </Typography>
          <Typography variant="body2" sx={{ mb: 3 }}>
            Please accept our terms of service to continue using Soul Medicine.
          </Typography>
          <FormControlLabel
            control={
              <Checkbox
                checked={termsAccepted}
                onChange={(e) => setTermsAccepted(e.target.checked)}
              />
            }
            label={
              <Typography variant="body2">
                I accept the{' '}
                <MuiLink href="/terms" target="_blank">
                  Terms of Service
                </MuiLink>{' '}
                and{' '}
                <MuiLink href="/privacy" target="_blank">
                  Privacy Policy
                </MuiLink>
              </Typography>
            }
          />
          <Button
            variant="contained"
            fullWidth
            disabled={!termsAccepted}
            onClick={() => {
              // Update user terms acceptance
              // This would need to be implemented
            }}
            sx={{ mt: 2 }}
          >
            Continue
          </Button>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card sx={{ maxWidth: 400, mx: 'auto', mt: 4 }}>
      <CardContent>
        <Typography variant="h5" component="h1" gutterBottom>
          {isSignUp ? 'Create Account' : 'Sign In'}
        </Typography>
        
        {error && (
          <Alert severity="error" sx={{ mb: 2 }}>
            {error}
          </Alert>
        )}

        <Box component="form" onSubmit={handleSubmit}>
          <TextField
            fullWidth
            type="email"
            label="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            sx={{ mb: 2 }}
          />
          
          <TextField
            fullWidth
            type="password"
            label="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            sx={{ mb: 2 }}
          />

          {isSignUp && (
            <>
              <TextField
                fullWidth
                type="password"
                label="Confirm Password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                required
                sx={{ mb: 2 }}
              />
              
              <FormControlLabel
                control={
                  <Checkbox
                    checked={termsAccepted}
                    onChange={(e) => setTermsAccepted(e.target.checked)}
                  />
                }
                label={
                  <Typography variant="body2">
                    I accept the{' '}
                    <MuiLink href="/terms" target="_blank">
                      Terms of Service
                    </MuiLink>{' '}
                    and{' '}
                    <MuiLink href="/privacy" target="_blank">
                      Privacy Policy
                    </MuiLink>
                  </Typography>
                }
                sx={{ mb: 2 }}
              />
            </>
          )}

          <Button
            type="submit"
            variant="contained"
            fullWidth
            disabled={loading || (isSignUp && !termsAccepted)}
            sx={{ mb: 2 }}
          >
            {loading ? 'Please wait...' : (isSignUp ? 'Create Account' : 'Sign In')}
          </Button>

          <Button
            type="button"
            variant="text"
            fullWidth
            onClick={() => {
              setIsSignUp(!isSignUp);
              setError(null);
              setPassword('');
              setConfirmPassword('');
              setTermsAccepted(false);
            }}
          >
            {isSignUp ? 'Already have an account? Sign in' : "Don't have an account? Sign up"}
          </Button>
        </Box>
      </CardContent>
    </Card>
  );
}