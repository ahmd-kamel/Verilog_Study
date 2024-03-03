#include <systemc.h>

SC_MODULE(Arbiter) {
    sc_in<bool> req_agent1;
    sc_in<bool> req_agent2;
    sc_out<bool> grant_agent1;
    sc_out<bool> grant_agent2;

    bool grant_1, grant_2;

    SC_CTOR(Arbiter) {
        grant_1 = false;
        grant_2 = false;
        
        SC_THREAD(arbitrate);
        sensitive << req_agent1 << req_agent2;
    }

    void arbitrate() {
        while (true) {
            wait();

            if (req_agent1.read()) {
                grant_1 = true;
                grant_2 = false;
                grant_agent1.write(true);
                grant_agent2.write(false);
            } else if (req_agent2.read() && !req_agent1.read()) {
                grant_1 = false;
                grant_2 = true;
                grant_agent1.write(false);
                grant_agent2.write(true);
            }
            else{
                grant_1 = false;
                grant_2 = false;                
                grant_agent1.write(false);
                grant_agent2.write(false);
            }
        }
    }
};

void print(sc_signal<bool> &req_agent1, sc_signal<bool> &req_agent2,
    sc_signal<bool> &grant_agent1, sc_signal<bool> &grant_agent2){
    cout << "req_1 = " << req_agent1;
    cout << " req_2 = " << req_agent2;
    cout << " grant_1 = " << grant_agent1;
    cout << " grant_2 = " << grant_agent2 << endl;
}

int sc_main(int argc, char* argv[]) {
    sc_signal<bool> req_agent1;
    sc_signal<bool> req_agent2;
    sc_signal<bool> grant_agent1;
    sc_signal<bool> grant_agent2;

    Arbiter arbiter("arbiter");
    arbiter.req_agent1(req_agent1);
    arbiter.req_agent2(req_agent2);
    arbiter.grant_agent1(grant_agent1);
    arbiter.grant_agent2(grant_agent2);

    // Testbench
    sc_start(0, SC_NS);
    cout << "req_1 = " << req_agent1;
    cout << " req_2 = " << req_agent2;
    cout << " grant_1 = " << grant_agent1;
    cout << " grant_2 = " << grant_agent2 << endl;

    // Simulate requests
    req_agent1.write(true);
    req_agent2.write(false);
    sc_start(1, SC_NS);
    print(req_agent1, req_agent2, grant_agent1, grant_agent2);



    req_agent1.write(false);
    req_agent2.write(true);
    sc_start(1, SC_NS);
    print(req_agent1, req_agent2, grant_agent1, grant_agent2);


    req_agent1.write(true);
    req_agent2.write(true);
    sc_start(1, SC_NS);
    print(req_agent1, req_agent2, grant_agent1, grant_agent2);


    req_agent1.write(false);
    req_agent2.write(false);
    sc_start(1, SC_NS);
    print(req_agent1, req_agent2, grant_agent1, grant_agent2);

    return 0;
}
