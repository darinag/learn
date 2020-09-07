IEx.Helpers.c "config_local.ex"
IEx.Helpers.c "test_harness.ex"
IEx.Helpers.c "flooding_test.ex"
IEx.Helpers.c "Flooding.ex"
if Node.self == :"coord@CS-STF-00373" do
    for _ <- 1..10, do: TestHarness.test(&FloodingTest.run/2)
end
System.halt
