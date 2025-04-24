module c2 (a,b,c,d,e,z);

input a,b,c,d,e;
output z;

wire f, g, h, i, j, k;

assign g = c;
assign h = c;
and and1 (f, a, b);
nor nor1 (j, f, g);
and and2 (i, h, d);
or or1 (k, i, e);
or or2 (z, j, k);

endmodule

