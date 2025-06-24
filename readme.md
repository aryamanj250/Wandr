# 🌍 **Wandr** - Your AI Travel Execution Butler

> *From broke wanderers to memory makers in one command.*

## 🚀 **What is Wandr?**

Ever landed somewhere with your squad, limited cash, and zero plan? **Wandr** transforms *"We're broke in McLeodganj with 12 hours"* into a fully executed adventure through the power of multi-agent AI.

Unlike traditional travel apps that give you endless recommendations, **Wandr's AI agents actually execute everything** - they make phone calls, process bookings, handle payments, and coordinate group logistics, all from a single voice command.

## ✨ **The Magic**

**Say:** *"₹5000 budget, mountain vibes, beer included"*

**Wandr Does:**
- 🔍 **Research Agent** finds the perfect cliff-side cafe
- 📞 **Booking Agent** calls and reserves your table
- 🏔️ **Logistics Agent** books a trek guide
- 💰 **Payment Agent** handles group payments automatically
- 📱 **Coordinator** creates a live itinerary everyone follows

**Result:** You just show up and live your best life.

## 🎯 **Core Features**

### **🎤 Voice-First Experience**
- Natural language commands like Google Assistant
- No typing, no planning - just speak and go
- Built for spontaneous Gen Z travel

### **🤖 Multi-Agent AI System**
- **Coordinator Agent:** Orchestrates the entire experience
- **Research Agent:** Discovers and ranks locations using real-time data
- **Booking Agent:** Makes actual phone calls and reservations
- **Payment Agent:** Handles group payments and budget tracking
- **Logistics Agent:** Optimizes routes and manages timing

### **⚡ Real-Time Execution**
- Live agent status updates on your phone
- Instant rebooking if plans change
- Location-based reminders keep everyone synced
- Weather-based replanning

### **💸 Smart Group Coordination**
- Automatic bill splitting
- UPI/Razorpay integration
- Budget enforcement and tracking
- Group payment notifications

## 🛠️ **Technology Stack**

### **Frontend**
- **iOS App:** SwiftUI with real-time agent dashboard
- **Voice Interface:** Seamless audio input processing
- **Live Updates:** WebSocket integration for agent status

### **Backend**
- **Framework:** Flask (Python)
- **AI Engine:** Gemini 2.0 Flash for voice processing
- **Agent System:** LangChain + Custom orchestration
- **Database:** SQLite (hackathon) / PostgreSQL (production)

### **Integrations**
- **🗣️ Voice Processing:** Gemini 2.0 Flash with audio
- **📍 Location Data:** Google Places API
- **📞 Phone Calls:** Twilio Voice API
- **💳 Payments:** Razorpay/UPI
- **🗺️ Route Planning:** Google Maps API
- **📅 Scheduling:** Google Calendar sync
- **💬 Group Chat:** WhatsApp Business API

## 🏗️ **Architecture**

```
Voice Command → Gemini Processing → Agent Orchestration → Real-World Execution
     ↓              ↓                    ↓                      ↓
  "Goa vibes"   → Structured Data → Multi-Agent Tasks → Booked Experience
```

### **Agent Flow:**
1. **User speaks:** *"We're in Goa, ₹5000 each, beach + party, 8 hours"*
2. **Gemini parses:** `{location: "Goa", budget: 5000, preferences: ["beach", "party"]}`
3. **Coordinator** creates task queue and assigns agents
4. **Research Agent** finds beach clubs and party spots
5. **Booking Agent** calls venues and makes reservations
6. **Payment Agent** handles group payments
7. **Logistics Agent** creates optimized itinerary
8. **User receives:** Complete executed plan with confirmations

## 🚀 **Getting Started**

### **Prerequisites**
- Python 3.9+
- iOS 14+ for mobile app
- API keys for: Gemini, Google Places, Twilio, Razorpay



### **Configuration**
Add your API keys to `.env`:
```
GEMINI_API_KEY=your_gemini_key
GOOGLE_PLACES_API_KEY=your_places_key
TWILIO_ACCOUNT_SID=your_twilio_sid
RAZORPAY_KEY_ID=your_razorpay_key
```

## 🎮 **Demo Scenarios**

### **Scenario 1: Beach Day in Goa**
**Voice Command:** *"Goa beach day, ₹3000 each, 6 hours, good vibes only"*
**Execution:** Finds beach shacks, books sunset table, arranges water sports, handles payments

### **Scenario 2: Mountain Adventure**
**Voice Command:** *"McLeodganj mountain vibes, ₹5000 budget, local food, full day"*
**Execution:** Books trek guide, reserves local restaurant, arranges transport, creates timeline

## 🎯 **Vision**

**The next "Google it" moment** - when friends need instant adventure, they'll just say **"Wandr it!"**

We're building the future where AI doesn't just recommend - it executes. No more decision paralysis, no more coordination headaches, no more missed opportunities.



## 🌟 **Built With Love**

For every broke wanderer who's ever said *"We're here, now what?"*

---

**Ready to turn your spontaneous travel dreams into reality?**

*Say it. Wandr does it. You live it.*