package com.picflower.dto;

import java.util.Date;

public class boardSearchDTO {
    private int b_no;
    private Date b_date;
    private String b_image;
    private String b_text;
    private int b_rating;
    private int b_like;
    private int m_no;
    private int p_no;
    private int b_status;

    // 표시용(조인)
    private String m_id;
    private String p_title;

    public int getB_no() { return b_no; }
    public void setB_no(int b_no) { this.b_no = b_no; }

    public Date getB_date() { return b_date; }
    public void setB_date(Date b_date) { this.b_date = b_date; }

    public String getB_image() { return b_image; }
    public void setB_image(String b_image) { this.b_image = b_image; }

    public String getB_text() { return b_text; }
    public void setB_text(String b_text) { this.b_text = b_text; }

    public int getB_rating() { return b_rating; }
    public void setB_rating(int b_rating) { this.b_rating = b_rating; }

    public int getB_like() { return b_like; }
    public void setB_like(int b_like) { this.b_like = b_like; }

    public int getM_no() { return m_no; }
    public void setM_no(int m_no) { this.m_no = m_no; }

    public int getP_no() { return p_no; }
    public void setP_no(int p_no) { this.p_no = p_no; }

    public int getB_status() { return b_status; }
    public void setB_status(int b_status) { this.b_status = b_status; }

    public String getM_id() { return m_id; }
    public void setM_id(String m_id) { this.m_id = m_id; }

    public String getP_title() { return p_title; }
    public void setP_title(String p_title) { this.p_title = p_title; }
}
