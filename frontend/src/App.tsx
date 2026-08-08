import { createBrowserRouter, RouterProvider, Outlet, Navigate } from 'react-router-dom'
import { Header } from './components/layout/Header'
import { StudyPlanSidebar } from './components/layout/StudyPlanSidebar'
import { PremiumExpiryBanner } from './components/PremiumExpiryBanner'
import { useAuth } from './contexts/AuthContext'
import { HomePage } from './pages/HomePage'
import { PracticePage } from './pages/PracticePage'
import { HistoryPage } from './pages/HistoryPage'
import { ProfilePage } from './pages/ProfilePage'
import { StarredPage } from './pages/StarredPage'
import { ReviewPage } from './pages/ReviewPage'
import { StudyPlanPage } from './pages/StudyPlanPage'
import { MobileUploadPage } from './pages/MobileUploadPage'
import { LandingPage } from './pages/LandingPage'

function RootLayout() {
  const { openUpgradeModal } = useAuth()
  return (
    // `overflow-x-clip`, not `hidden`: `clip` is the one value that leaves the other axis
    // `visible`, so the header's account dropdown still escapes downwards, and it doesn't
    // establish a scrollport, so the header's `position: sticky` keeps working. This is a
    // backstop — the header contains its own width now — for narrow phones where the action
    // cluster alone could still outgrow the screen and stretch every route to match.
    <div className="min-h-screen flex flex-col overflow-x-clip">
      <Header />
      <PremiumExpiryBanner onRenew={openUpgradeModal} />
      <div className="relative flex-1 overflow-hidden">
        <main className="flex-1 overflow-hidden flex flex-col">
          <Outlet />
        </main>
        <StudyPlanSidebar />
      </div>
    </div>
  )
}

const router = createBrowserRouter([
  // Lightweight phone upload page — standalone, no header/nav chrome.
  { path: '/m/:token', element: <MobileUploadPage /> },
  // Marketing landing page is the entry point — standalone nav/footer chrome.
  { path: '/', element: <LandingPage /> },
  // Main app — the roadmap lives at /roadmap; shares the header + study-plan sidebar.
  {
    element: <RootLayout />,
    children: [
      { path: 'roadmap', element: <HomePage /> },
      { path: 'practice/:topicId', element: <PracticePage /> },
      { path: 'history', element: <HistoryPage /> },
      { path: 'profile', element: <ProfilePage /> },
      { path: 'stats', element: <Navigate to="/profile" replace /> },
      { path: 'starred', element: <StarredPage /> },
      { path: 'review', element: <ReviewPage /> },
      { path: 'study-plan', element: <StudyPlanPage /> },
    ],
  },
])

export default function App() {
  return <RouterProvider router={router} />
}
