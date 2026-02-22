'use client';

import React from 'react';

export default function CVPage() {
    // Print automatically when loaded
    React.useEffect(() => {
        const timer = setTimeout(() => {
            // window.print(); // Uncomment to auto-print on load if desired
        }, 800);
        return () => clearTimeout(timer);
    }, []);

    return (
        <div className="cv-wrapper">
            <style jsx global>{`
                :root {
                    --cv-primary: #0f172a;
                    --cv-accent: #0ea5e9;
                    --cv-text-main: #1e293b;
                    --cv-text-muted: #64748b;
                    --cv-border: #e2e8f0;
                    --cv-sidebar-text: #f1f5f9;
                }

                @media print {
                    @page {
                        margin: 0;
                        size: A4;
                    }
                    body {
                        margin: 0;
                        -webkit-print-color-adjust: exact;
                        print-color-adjust: exact;
                    }
                    .no-print {
                        display: none !important;
                    }
                    .cv-wrapper {
                        margin: 0 !important;
                        padding: 0 !important;
                        box-shadow: none !important;
                        width: 100% !important;
                        height: 297mm !important;
                    }
                }

                body {
                    background: #f1f5f9;
                    font-family: 'Inter', -apple-system, system-ui, sans-serif;
                    margin: 0;
                    padding: 0;
                    color: var(--cv-text-main);
                }

                .cv-wrapper {
                    max-width: 900px;
                    margin: 40px auto;
                    background: white;
                    box-shadow: 0 20px 50px rgba(0,0,0,0.15);
                    min-height: 297mm;
                    display: grid;
                    grid-template-columns: 300px 1fr;
                    position: relative;
                    overflow: hidden;
                }

                /* Sidebar Styles */
                .sidebar {
                    background: var(--cv-primary);
                    color: var(--cv-sidebar-text);
                    padding: 50px 35px;
                    display: flex;
                    flex-direction: column;
                    border-right: 1px solid rgba(255,255,255,0.05);
                }

                .profile-section {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    text-align: center;
                    margin-bottom: 40px;
                }

                .profile-img-container {
                    width: 170px;
                    height: 170px;
                    border-radius: 50%;
                    padding: 8px;
                    background: linear-gradient(135deg, var(--cv-accent) 0%, #1e293b 100%);
                    box-shadow: 0 10px 25px rgba(0,0,0,0.4);
                    margin-bottom: 25px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .profile-img {
                    width: 100%;
                    height: 100%;
                    border-radius: 50%;
                    object-fit: cover;
                    border: 3px solid rgba(255,255,255,0.1);
                    background: #1e293b;
                }

                .name-header h1 {
                    font-size: 34px;
                    font-weight: 800;
                    margin: 0;
                    letter-spacing: -0.5px;
                    color: white;
                }

                .name-header .title {
                    font-size: 13px;
                    color: var(--cv-accent);
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: 2px;
                    margin-top: 10px;
                    background: rgba(14, 165, 233, 0.1);
                    padding: 4px 12px;
                    border-radius: 20px;
                    display: inline-block;
                }

                .sidebar-section {
                    margin-bottom: 30px;
                }

                .sidebar-title {
                    font-size: 12px;
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: 1.5px;
                    color: var(--cv-accent);
                    margin-bottom: 18px;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .sidebar-title::after {
                    content: '';
                    flex: 1;
                    height: 1px;
                    background: rgba(255,255,255,0.1);
                }

                .contact-list {
                    list-style: none;
                    padding: 0;
                    margin: 0;
                }

                .contact-item {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    margin-bottom: 14px;
                    font-size: 12.5px;
                    color: #cbd5e1;
                }

                .contact-icon {
                    font-size: 16px;
                    color: var(--cv-accent);
                }

                .skills-container {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 6px;
                }

                .skill-tag {
                    background: rgba(255,255,255,0.06);
                    padding: 5px 12px;
                    border-radius: 6px;
                    font-size: 10.5px;
                    border: 1px solid rgba(255,255,255,0.1);
                    color: #e2e8f0;
                }

                /* Main Content Styles */
                .main-content {
                    padding: 60px 45px;
                    background: white;
                }

                .section {
                    margin-bottom: 35px;
                }

                .section-header {
                    display: flex;
                    align-items: center;
                    gap: 15px;
                    margin-bottom: 20px;
                }

                .section-header h2 {
                    font-size: 18px;
                    font-weight: 800;
                    margin: 0;
                    text-transform: uppercase;
                    letter-spacing: 1.5px;
                    color: var(--cv-primary);
                }

                .section-header .line {
                    flex: 1;
                    height: 2px;
                    background: #f1f5f9;
                }

                .summary-text {
                    font-size: 14px;
                    line-height: 1.8;
                    color: #334155;
                    margin: 0;
                    text-align: justify;
                }

                .experience-item {
                    margin-bottom: 30px;
                    position: relative;
                }

                .exp-top {
                    display: flex;
                    justify-content: space-between;
                    align-items: baseline;
                    margin-bottom: 8px;
                }

                .company {
                    font-size: 16px;
                    font-weight: 700;
                    color: var(--cv-primary);
                }

                .period {
                    font-size: 11px;
                    color: var(--cv-primary);
                    font-weight: 700;
                    background: #e0f2fe;
                    padding: 3px 10px;
                    border-radius: 12px;
                }

                .role {
                    font-size: 14px;
                    color: var(--cv-accent);
                    font-weight: 700;
                    margin-bottom: 12px;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }

                .role::before {
                    content: '▹';
                    font-weight: 400;
                }

                .exp-list {
                    padding-left: 20px;
                    margin: 0;
                }

                .exp-list li {
                    font-size: 13px;
                    line-height: 1.7;
                    color: #475569;
                    margin-bottom: 8px;
                }

                .project-card {
                    background: #f8fafc;
                    border-left: 4px solid var(--cv-accent);
                    padding: 20px;
                    border-radius: 0 12px 12px 0;
                    margin-bottom: 15px;
                }

                .project-title {
                    font-size: 15px;
                    font-weight: 700;
                    margin-bottom: 8px;
                    color: var(--cv-primary);
                }

                .project-desc {
                    font-size: 13px;
                    color: #475569;
                    line-height: 1.6;
                    margin: 0;
                }

                .print-controls {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    z-index: 1000;
                }

                .btn-primary {
                    background: var(--cv-primary);
                    color: white;
                    border: none;
                    padding: 12px 24px;
                    border-radius: 10px;
                    font-weight: 700;
                    font-size: 14px;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    box-shadow: 0 10px 20px rgba(15, 23, 42, 0.2);
                    transition: all 0.2s;
                }

                .btn-primary:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 15px 30px rgba(15, 23, 42, 0.3);
                }
            `}</style>

            <div className="print-controls no-print">
                <button className="btn-primary" onClick={() => window.print()}>
                    <span>📄</span> Guardar como PDF / Imprimir
                </button>
            </div>

            {/* Sidebar */}
            <aside className="sidebar">
                <div className="profile-section">
                    <div className="profile-img-container">
                        <img src="/cv-profile.png" alt="Luigis" className="profile-img" />
                    </div>
                    <div className="name-header">
                        <h1>Luigis</h1>
                        <div className="title">Java Backend Developer</div>
                    </div>
                </div>

                <div className="sidebar-section">
                    <div className="sidebar-title">Contacto</div>
                    <ul className="contact-list">
                        <li className="contact-item">
                            <span className="contact-icon">📧</span>
                            Available on request
                        </li>
                        <li className="contact-item">
                            <span className="contact-icon">📱</span>
                            +57 300 000 0000
                        </li>
                        <li className="contact-item">
                            <span className="contact-icon">📍</span>
                            Remoto / Presencial
                        </li>
                        <li className="contact-item">
                            <span className="contact-icon">🔗</span>
                            linkedin.com/in/luigis
                        </li>
                        <li className="contact-item">
                            <span className="contact-icon">🐙</span>
                            github.com/luigis
                        </li>
                    </ul>
                </div>

                <div className="sidebar-section">
                    <div className="sidebar-title">Habilidades Core</div>
                    <div className="skills-container">
                        {[
                            'Java 17+', 'Spring Boot 3', 'Microservices',
                            'Hexagonal Arch', 'Clean Arch', 'OAuth2/JWT',
                            'PostgreSQL', 'Oracle DB', 'PL/SQL',
                            'Docker / K8s', 'RabbitMQ', 'Node.js',
                            'React / Next.js', 'ZK Framework', 'PHP / Bootstrap'
                        ].map(skill => (
                            <span key={skill} className="skill-tag">{skill}</span>
                        ))}
                    </div>
                </div>

                <div className="sidebar-section" style={{ marginTop: 'auto', marginBottom: 0 }}>
                    <div className="sidebar-title">Idiomas</div>
                    <div className="contact-item">
                        <span style={{ color: 'var(--cv-accent)', fontWeight: 700 }}>ES</span>
                        <span>Español (Nativo)</span>
                    </div>
                    <div className="contact-item">
                        <span style={{ color: 'var(--cv-accent)', fontWeight: 700 }}>EN</span>
                        <span>Inglés (Técnico / B1)</span>
                    </div>
                </div>
            </aside>

            {/* Main Content */}
            <main className="main-content">
                <section className="section">
                    <div className="section-header">
                        <h2>Perfil Profesional</h2>
                        <div className="line" />
                    </div>
                    <p className="summary-text">
                        Desarrollador Backend Java con más de 3 años de experiencia en el diseño y construcción de sistemas empresariales escalables y de alta disponibilidad. Experto en el ecosistema Spring, microservicios y arquitecturas limpias. Especializado en sectores financieros y educativos (ERP), con un fuerte enfoque en la seguridad (OAuth2/RBAC) y la optimización de procesos críticos. Comprometido con la calidad del código, el aprendizaje continuo y la entrega de soluciones tecnológicas que generen impacto real en el negocio.
                    </p>
                </section>

                <section className="section">
                    <div className="section-header">
                        <h2>Experiencia Laboral</h2>
                        <div className="line" />
                    </div>

                    <div className="experience-item">
                        <div className="exp-top">
                            <span className="company">Proyectos Propios / Desarrollo Freelance</span>
                            <span className="period">Ene 2026 — Presente</span>
                        </div>
                        <div className="role">Desarrollador Backend Java</div>
                        <ul className="exp-list">
                            <li>Liderazgo técnico en el desarrollo de microservicios para gestión financiera.</li>
                            <li>Arquitectura e implementación de Servidores de Autorización OAuth2 con JWT personalizados.</li>
                            <li>Desarrollo de módulos core para ERP financiero (Gestión de Créditos y Parametrización).</li>
                            <li>Uso de Docker y Kubernetes para la orquestación de servicios empresariales.</li>
                        </ul>
                    </div>

                    <div className="experience-item">
                        <div className="exp-top">
                            <span className="company">Caseware Ingeniería S.A.S.</span>
                            <span className="period">2020 — Ago 2025</span>
                        </div>
                        <div className="role">Desarrollador Java (ERP Financiero)</div>
                        <ul className="exp-list">
                            <li>Desarrollador clave en el ERP financiero líder para educación superior en la región.</li>
                            <li>Implementación de procesos de negocio complejos integrando ZK Framework y Spring Boot.</li>
                            <li>Optimización y modelado de bases de datos relacionales en Oracle y PostgreSQL.</li>
                            <li>Mantenimiento evolutivo de plataformas de misión crítica con altos estándares de seguridad.</li>
                        </ul>
                    </div>

                    <div className="experience-item">
                        <div className="exp-top">
                            <span className="company">Sistemas AsapAseco</span>
                            <span className="period">2018 — 2020</span>
                        </div>
                        <div className="role">Desarrollador de Software Jr (PHP)</div>
                        <ul className="exp-list">
                            <li>Desarrollo de softwares a la medida utilizando PHP (CodeIgniter) y Bootstrap.</li>
                            <li>Gestión y administración de servidores web para despliegue de aplicaciones productivas.</li>
                            <li>Mantenimiento de bases de datos y soporte técnico especializado a nivel de código.</li>
                        </ul>
                    </div>
                </section>

                <section className="section">
                    <div className="section-header">
                        <h2>Proyectos y Logros</h2>
                        <div className="line" />
                    </div>

                    <div className="project-card">
                        <div className="project-title">Sistema de Gestión de Créditos (FinTech)</div>
                        <p className="project-desc">
                            Desarrollo integral de una plataforma que automatiza el ciclo de vida del crédito. Implementa seguridad Zero-Trust y auditoría total de transacciones financieras.
                        </p>
                    </div>

                    <div className="project-card">
                        <div className="project-title">Ecosistema de Microservicios IAM</div>
                        <p className="project-desc">
                            Centralización de la identidad y accesos mediante un sistema RBAC granular, asegurando más de 50 endpoints con políticas de autorización dinámicas.
                        </p>
                    </div>
                </section>
            </main>
        </div>
    );
}
