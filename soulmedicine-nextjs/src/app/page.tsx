'use client';

import { 
  Container, 
  Typography, 
  Box, 
  Button, 
  Card, 
  CardContent,
  Grid 
} from '@mui/material';
import { useAuth } from '@/hooks/useAuth';
import SignIn from '@/components/auth/SignIn';
import Profile from '@/components/profile/Profile';
import CookieBanner from '@/components/common/CookieBanner';
import LeaveSite from '@/components/common/LeaveSite';

export default function Home() {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <Container maxWidth="md" sx={{ py: 4, textAlign: 'center' }}>
        <Typography>Loading...</Typography>
      </Container>
    );
  }

  return (
    <>
      <LeaveSite />
      <Container maxWidth="md" sx={{ py: 4 }}>
        <Box sx={{ textAlign: 'center', mb: 4 }}>
          <Typography variant="h2" component="h1" gutterBottom>
            Soul Medicine
          </Typography>
          <Typography variant="h6" color="text.secondary">
            Healing pathways for your journey
          </Typography>
        </Box>

        {!user ? (
          <Box>
            <SignIn />
            <Box sx={{ mt: 4, textAlign: 'center' }}>
              <Typography variant="h5" gutterBottom>
                Welcome to Soul Medicine
              </Typography>
              <Typography variant="body1" sx={{ mb: 3 }}>
                Discover healing pathways designed to support your journey of growth and recovery.
                Create an account to access our courses and personalized content.
              </Typography>
              
              <Grid container spacing={3} sx={{ mt: 2 }}>
                <Grid item xs={12} md={4}>
                  <Card>
                    <CardContent>
                      <Typography variant="h6" gutterBottom>
                        Personalized Pathways
                      </Typography>
                      <Typography variant="body2">
                        Custom learning paths tailored to your healing journey
                      </Typography>
                    </CardContent>
                  </Card>
                </Grid>
                <Grid item xs={12} md={4}>
                  <Card>
                    <CardContent>
                      <Typography variant="h6" gutterBottom>
                        Expert Content
                      </Typography>
                      <Typography variant="body2">
                        Evidence-based content from healing professionals
                      </Typography>
                    </CardContent>
                  </Card>
                </Grid>
                <Grid item xs={12} md={4}>
                  <Card>
                    <CardContent>
                      <Typography variant="h6" gutterBottom>
                        Community Support
                      </Typography>
                      <Typography variant="body2">
                        Connect with others on similar healing journeys
                      </Typography>
                    </CardContent>
                  </Card>
                </Grid>
              </Grid>
            </Box>
          </Box>
        ) : (
          <Box>
            <Typography variant="h4" gutterBottom>
              Welcome back, {user.displayName}!
            </Typography>
            
            {!user.emailVerified && (
              <Box sx={{ mb: 3 }}>
                <Card sx={{ bgcolor: 'warning.light' }}>
                  <CardContent>
                    <Typography variant="h6">Email Verification Required</Typography>
                    <Typography variant="body2">
                      Please check your email and click the verification link to access all features.
                    </Typography>
                  </CardContent>
                </Card>
              </Box>
            )}

            <Grid container spacing={3}>
              <Grid item xs={12} md={6}>
                <Card>
                  <CardContent>
                    <Typography variant="h6" gutterBottom>
                      My Pathways
                    </Typography>
                    <Typography variant="body2" sx={{ mb: 2 }}>
                      Continue your healing journey
                    </Typography>
                    <Button variant="contained" disabled>
                      View Pathways (Coming Soon)
                    </Button>
                  </CardContent>
                </Card>
              </Grid>
              <Grid item xs={12} md={6}>
                <Card>
                  <CardContent>
                    <Typography variant="h6" gutterBottom>
                      My Progress
                    </Typography>
                    <Typography variant="body2" sx={{ mb: 2 }}>
                      Track your learning journey
                    </Typography>
                    <Button variant="outlined" disabled>
                      View Progress (Coming Soon)
                    </Button>
                  </CardContent>
                </Card>
              </Grid>
            </Grid>

            <Box sx={{ mt: 4 }}>
              <Profile />
            </Box>
          </Box>
        )}
      </Container>
      <CookieBanner />
    </>
  );
}
