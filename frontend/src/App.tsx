import { createBrowserRouter, RouterProvider, Outlet } from 'react-router-dom'
import { Header } from './components/layout/Header'
import { StudyPlanSidebar } from './components/layout/StudyPlanSidebar'
import { HomePage } from './pages/HomePage'
import { PracticePage } from './pages/PracticePage'
import { HistoryPage } from './pages/HistoryPage'
import { StatsPage } from './pages/StatsPage'
import { StarredPage } from './pages/StarredPage'
import { ReviewPage } from './pages/ReviewPage'
import { StudyPlanPage } from './pages/StudyPlanPage'
import { MobileUploadPage } from './pages/MobileUploadPage'
import { LandingPage } from './pages/LandingPage'

function RootLayout() {
  return (
    <div className="min-h-screen flex flex-col">
      <Header />
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
      { path: 'stats', element: <StatsPage /> },
      { path: 'starred', element: <StarredPage /> },
      { path: 'review', element: <ReviewPage /> },
      { path: 'study-plan', element: <StudyPlanPage /> },
    ],
  },
])

export default function App() {
  return <RouterProvider router={router} />
}
