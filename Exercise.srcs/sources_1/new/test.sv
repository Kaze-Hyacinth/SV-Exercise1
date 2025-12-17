always_ff @( posedge clk or posedge rst) begin
        if (rst == 1) begin
            l2_cnt <= 0;
        end
        else begin
            if(en == 1) begin
                if(l2_cnt == l2_max) begin
                    l2_cnt <= 0;
                end
                else begin
                    l2_cnt <= l2_cnt + 1;
                end
            end
            else begin
                l2_cnt <= l2_cnt;
            end
        end
    end