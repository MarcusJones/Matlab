% This script merges the off condition with the ambient state

Air.Proc.Temp = Air.Proc.Temp + (Air.Amb.Temp-Air.Proc.Temp).*(1 -Energy.OnOff);
Air.Reg.Temp = Air.Reg.Temp + (Air.Amb.Temp-Air.Reg.Temp).*(1 -Energy.OnOff);

Air.Proc.W = Air.Proc.W + (Air.Amb.W-Air.Proc.W).*(1 -Energy.OnOff);
Air.Reg.W = Air.Reg.W + (Air.Amb.W-Air.Reg.W).*(1 -Energy.OnOff);

Air.Proc.H = Air.Proc.H + (Air.Amb.H-Air.Proc.H).*(1 -Energy.OnOff);
Air.Reg.H = Air.Reg.H + (Air.Amb.H-Air.Reg.H).*(1 -Energy.OnOff);

Air.Proc.RH = Air.Proc.RH + (Air.Amb.RH-Air.Proc.RH).*(1 -Energy.OnOff);

Air.FlowKH = Air.FlowKH.*Energy.OnOff;
Air.FlowRegenKH = Air.FlowRegenKH.*Energy.OnOff;

Des.C.ConcIn = Energy.OnOff .* Des.C.ConcIn;
Des.C.ConcOut = Energy.OnOff .* Des.C.ConcOut;
Des.R.ConcIn = Energy.OnOff .* Des.R.ConcIn;
Des.R.ConcOut = Energy.OnOff .* Des.R.ConcOut;