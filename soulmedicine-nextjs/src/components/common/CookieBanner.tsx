'use client';

import { useState, useEffect } from 'react';
import {
  Box,
  Button,
  Typography,
  Paper,
  Link as MuiLink,
} from '@mui/material';

export default function CookieBanner() {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    // Check if user has already accepted cookies
    const hasAcceptedCookies = localStorage.getItem('cookies-accepted');
    if (!hasAcceptedCookies) {
      setIsVisible(true);
    }
  }, []);

  const handleAccept = () => {
    localStorage.setItem('cookies-accepted', 'true');
    setIsVisible(false);
  };

  const handleDecline = () => {
    localStorage.setItem('cookies-accepted', 'false');
    setIsVisible(false);
  };

  if (!isVisible) {
    return null;
  }

  return (
    <Paper
      sx={{
        position: 'fixed',
        bottom: 0,
        left: 0,
        right: 0,
        zIndex: 1000,
        p: 2,
        backgroundColor: 'background.paper',
        borderTop: '1px solid',
        borderColor: 'divider',
      }}
      elevation={3}
    >
      <Box
        sx={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          flexWrap: 'wrap',
          gap: 2,
        }}
      >
        <Typography variant="body2" sx={{ flex: 1, minWidth: '300px' }}>
          We use cookies to enhance your experience on our website. By continuing to use our site, 
          you agree to our use of cookies.{' '}
          <MuiLink href="/privacy" target="_blank" color="primary">
            Learn more
          </MuiLink>
        </Typography>
        
        <Box sx={{ display: 'flex', gap: 1 }}>
          <Button
            variant="outlined"
            size="small"
            onClick={handleDecline}
          >
            Decline
          </Button>
          <Button
            variant="contained"
            size="small"
            onClick={handleAccept}
          >
            Accept
          </Button>
        </Box>
      </Box>
    </Paper>
  );
}