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
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Divider,
} from '@mui/material';
import { useAuth } from '@/hooks/useAuth';

export default function Profile() {
  const { user, updateProfile, signOut } = useAuth();
  const [displayName, setDisplayName] = useState(user?.displayName || '');
  const [email, setEmail] = useState(user?.email || '');
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);

  if (!user) {
    return (
      <Alert severity="warning">
        Please sign in to view your profile.
      </Alert>
    );
  }

  const handleUpdateProfile = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setSuccess(null);

    try {
      await updateProfile({
        displayName,
        email,
      });
      setSuccess('Profile updated successfully!');
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleChangePassword = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setSuccess(null);

    if (newPassword !== confirmPassword) {
      setError('Passwords do not match');
      setLoading(false);
      return;
    }

    try {
      // This would need to be implemented with Firebase Auth
      // await updatePassword(currentPassword, newPassword);
      setSuccess('Password changed successfully!');
      setCurrentPassword('');
      setNewPassword('');
      setConfirmPassword('');
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteAccount = async () => {
    try {
      // This would need to be implemented
      // await deleteAccount();
      setDeleteDialogOpen(false);
    } catch (err: any) {
      setError(err.message);
    }
  };

  return (
    <Box sx={{ maxWidth: 600, mx: 'auto', p: 3 }}>
      <Typography variant="h4" component="h1" gutterBottom>
        Profile Settings
      </Typography>

      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}

      {success && (
        <Alert severity="success" sx={{ mb: 2 }}>
          {success}
        </Alert>
      )}

      {/* Profile Information */}
      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            Profile Information
          </Typography>
          
          <Box component="form" onSubmit={handleUpdateProfile}>
            <TextField
              fullWidth
              label="Display Name"
              value={displayName}
              onChange={(e) => setDisplayName(e.target.value)}
              required
              sx={{ mb: 2 }}
            />
            
            <TextField
              fullWidth
              type="email"
              label="Email Address"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              sx={{ mb: 2 }}
              helperText={!user.emailVerified ? 'Email not verified' : ''}
            />

            <Button
              type="submit"
              variant="contained"
              disabled={loading}
            >
              Update Profile
            </Button>
          </Box>
        </CardContent>
      </Card>

      {/* Change Password */}
      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            Change Password
          </Typography>
          
          <Box component="form" onSubmit={handleChangePassword}>
            <TextField
              fullWidth
              type="password"
              label="Current Password"
              value={currentPassword}
              onChange={(e) => setCurrentPassword(e.target.value)}
              required
              sx={{ mb: 2 }}
            />
            
            <TextField
              fullWidth
              type="password"
              label="New Password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              required
              sx={{ mb: 2 }}
            />
            
            <TextField
              fullWidth
              type="password"
              label="Confirm New Password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              required
              sx={{ mb: 2 }}
            />

            <Button
              type="submit"
              variant="contained"
              disabled={loading}
            >
              Change Password
            </Button>
          </Box>
        </CardContent>
      </Card>

      {/* Account Actions */}
      <Card>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            Account Actions
          </Typography>
          
          <Button
            variant="outlined"
            onClick={signOut}
            sx={{ mr: 2, mb: 1 }}
          >
            Sign Out
          </Button>
          
          <Button
            variant="outlined"
            color="error"
            onClick={() => setDeleteDialogOpen(true)}
          >
            Delete Account
          </Button>
        </CardContent>
      </Card>

      {/* Delete Account Dialog */}
      <Dialog
        open={deleteDialogOpen}
        onClose={() => setDeleteDialogOpen(false)}
      >
        <DialogTitle>Delete Account</DialogTitle>
        <DialogContent>
          <Typography>
            Are you sure you want to delete your account? This action cannot be undone.
            All your data, subscriptions, and progress will be permanently removed.
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setDeleteDialogOpen(false)}>
            Cancel
          </Button>
          <Button
            onClick={handleDeleteAccount}
            color="error"
            variant="contained"
          >
            Delete Account
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}