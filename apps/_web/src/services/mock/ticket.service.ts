export interface Ticket {
  id: string;
  date: string;
  subject: string;
  status: 'Pending' | 'Resolved';
}

// Mock Data
let mockTickets: Ticket[] = [
  {
    id: '#786',
    date: '25/09/2021',
    subject: 'Query about return & exchange',
    status: 'Pending'
  },
  {
    id: '#453',
    date: '20/10/2021',
    subject: 'Query about return & exchange',
    status: 'Pending'
  },
  {
    id: '#456',
    date: '10/11/2021',
    subject: 'Payment processing issue',
    status: 'Resolved'
  }
];

export const TicketService = {
  getTickets: (): Ticket[] => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem('aba_mock_tickets');
      if (stored) return JSON.parse(stored);
      localStorage.setItem('aba_mock_tickets', JSON.stringify(mockTickets));
    }
    return mockTickets;
  },

  deleteTicket: (ticketId: string): void => {
    const tickets = TicketService.getTickets();
    const updatedTickets = tickets.filter(t => t.id !== ticketId);
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_tickets', JSON.stringify(updatedTickets));
    }
    mockTickets = updatedTickets;
  }
};
