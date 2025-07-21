'use client';

import { Button } from '@mui/material';
import ExitToAppIcon from '@mui/icons-material/ExitToApp';
import { useAuth } from '@/hooks/useAuth';

export default function LeaveSite() {
  const { signOut, user } = useAuth();

  const handleLeaveSite = async () => {
    try {
      // Sign out if user is signed in
      if (user) {
        await signOut();
      }
      
      // Open Wikipedia in new tab
      window.open('https://en.wikipedia.org', '_blank');
      
      // Redirect current page to cute baby animals
      window.location.href = 'https://www.google.com/search?q=cute+baby+animals&tbm=isch';
    } catch (error) {
      console.error('Error leaving site:', error);
      // Still redirect even if sign out fails
      window.open('https://en.wikipedia.org', '_blank');
      window.location.href = 'https://www.google.com/search?q=cute+baby+animals&tbm=isch';
    }
  };

  return (
    <Button
      variant="outlined"
      startIcon={<ExitToAppIcon />}
      onClick={handleLeaveSite}
      size="small"
      sx={{
        position: 'fixed',
        top: 16,
        right: 16,
        zIndex: 1000,
        backgroundColor: 'background.paper',
        borderColor: 'error.main',
        color: 'error.main',
        '&:hover': {
          backgroundColor: 'error.main',
          color: 'common.white',
        },
      }}
    >
      Quick Exit
    </Button>
  );
}