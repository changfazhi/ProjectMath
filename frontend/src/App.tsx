import { createBrowserRouter, RouterProvider, Outlet } from 'react-router-dom'
import { ThemeProvider } from './contexts/ThemeContext'
import { Header } from './components/layout/Header'
import { HomePage } from './pages/HomePage'
import { PracticePage } from './pages/PracticePage'
import { HistoryPage } from './pages/HistoryPage'
import { StatsPage } from './pages/StatsPage'
import { StarredPage } from './pages/StarredPage'
import { ReviewPage } from './pages/ReviewPage'
import { StudyPlanPage } from './pages/StudyPlanPage'
import { MobileUploadPage } from './pages/MobileUploadPage'

function RootLayout() {
  return (
    <div className="min-h-screen flex flex-col">
      <Header />
      <main className="flex-1 overflow-hidden flex flex-col">
        <Outlet />
      </main>
    </div>
  )
}

const router = createBrowserRouter([
  // Lightweight phone upload page — standalone, no header/nav chrome.
  { path: '/m/:token', element: <MobileUploadPage /> },
  {
    path: '/',
    element: <RootLayout />,
    children: [
      { index: true, element: <HomePage /> },
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
  return (
    <ThemeProvider>
      <RouterProvider router={router} />
    </ThemeProvider>
  )
}
