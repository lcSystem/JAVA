'use client';

import React, { useState, FormEvent } from 'react';

export default function ContactWindow() {
    const [formData, setFormData] = useState({ name: '', email: '', message: '' });
    const [sent, setSent] = useState(false);

    const handleSubmit = (e: FormEvent) => {
        e.preventDefault();
        setSent(true);
        setTimeout(() => setSent(false), 3000);
    };

    return (
        <div style={{ padding: 24, height: '100%', overflow: 'auto' }}>
            <div className="section-heading">Get in Touch</div>

            {/* Contact methods */}
            <div style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fill, minmax(180px, 1fr))',
                gap: 12,
                marginBottom: 24,
            }}>
                {[
                    { icon: '📧', label: 'Email', value: 'Available on request', link: '#' },
                    { icon: '💼', label: 'LinkedIn', value: 'Connect with me', link: '#' },
                    { icon: '🐙', label: 'GitHub', value: 'View my repos', link: '#' },
                    { icon: '🌍', label: 'Location', value: 'Open to relocation', link: null },
                ].map(item => (
                    <div
                        key={item.label}
                        style={{
                            padding: '14px 16px',
                            background: 'rgba(255,255,255,0.02)',
                            border: '1px solid var(--win-border)',
                            borderRadius: 8,
                            cursor: item.link ? 'pointer' : 'default',
                            transition: 'border-color 0.2s',
                        }}
                        onMouseEnter={e => { if (item.link) (e.currentTarget.style.borderColor = 'rgba(0,120,212,0.4)'); }}
                        onMouseLeave={e => (e.currentTarget.style.borderColor = 'var(--win-border)')}
                    >
                        <div style={{ fontSize: 20, marginBottom: 6 }}>{item.icon}</div>
                        <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--win-text)', marginBottom: 2 }}>{item.label}</div>
                        <div style={{ fontSize: 11, color: 'var(--win-text-secondary)' }}>{item.value}</div>
                    </div>
                ))}
            </div>

            {/* Contact form */}
            <div className="section-heading">Send a Message</div>
            <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 12, maxWidth: 420 }}>
                <input
                    className="contact-input"
                    placeholder="Your Name"
                    value={formData.name}
                    onChange={e => setFormData({ ...formData, name: e.target.value })}
                    required
                />
                <input
                    className="contact-input"
                    type="email"
                    placeholder="Your Email"
                    value={formData.email}
                    onChange={e => setFormData({ ...formData, email: e.target.value })}
                    required
                />
                <textarea
                    className="contact-input"
                    placeholder="Your Message"
                    rows={4}
                    style={{ resize: 'vertical' }}
                    value={formData.message}
                    onChange={e => setFormData({ ...formData, message: e.target.value })}
                    required
                />
                <button
                    type="submit"
                    style={{
                        padding: '10px 24px',
                        background: sent ? '#16c60c' : 'var(--win-accent)',
                        border: 'none',
                        borderRadius: 6,
                        color: 'white',
                        fontSize: 13,
                        fontWeight: 600,
                        cursor: 'pointer',
                        transition: 'background 0.2s',
                        alignSelf: 'flex-start',
                    }}
                >
                    {sent ? '✅ Message Sent!' : '📤 Send Message'}
                </button>
            </form>
        </div>
    );
}
