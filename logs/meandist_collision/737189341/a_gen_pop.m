function Pop = a_gen_pop(data, settings)
    Fit = data.fits;
    Pop = data.Pop;
    sigma = settings.sigma;
    space = settings.space;
    BestGenome=selbest(Pop,Fit',[1,1,1,1,1]);
    Old=seltourn(Pop,Fit',15);
    Work1=selsus(Pop,Fit',30);
    Work2=seltourn(Pop,Fit',100);
    Work1=crossov(Work1,1,0);
    Work2=muta(Work2,0.2,sigma,space);
    Work2=mutx(Work2,0.2,space);
    Pop=[BestGenome;Old;Work1;Work2];
end

