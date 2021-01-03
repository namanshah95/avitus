import { render, screen } from '@testing-library/react';
import App from './App';

test('renders basic App component', () => {
  render(<App />);
  const headerElement = screen.getByText(/Avitus Orthopaedics/);
  expect(headerElement).toBeInTheDocument();
});
