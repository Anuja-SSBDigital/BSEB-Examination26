<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExaminationForm.aspx.cs" Inherits="ExaminationForm" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BSEB Examination Form</title>
    <style>
        /* Your existing CSS styles go here */
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }

        .lineheart_a {
            line-height: 1.4;
        }

        .lineheart_b {
            line-height: 1.07;
        }




        .form-header {
            text-align: center;
        }

            .form-header .board-title {
                font-size: 18px;
                text-transform: uppercase;
            }

            .form-header .exam-title {
                font-size: 16px;
                text-decoration: underline;
                margin-bottom: 30px;
            }

        .faculty-box {
            text-align: right;
            margin-top: -30px;
            margin-bottom: 10px;
        }

            .faculty-box span {
                border: 1px solid black;
                padding: 5px 20px;
                font-weight: normal;
            }

        .hindi-line {
            text-align: center;
            margin-top: 10px;
            font-size: 16px;
        }

        .session-line {
            text-align: center;
            font-weight: bold;
            margin-top: 5px;
            font-size: 16px;
        }

            .session-line u {
                text-decoration: underline;
            }

        .container {
            width: 800px;
            margin: 0 auto;
            border: 1px solid #000;
            padding: 20px;
            page-break-after: always; /* This will create a new page for each student */
        }

        .header, .section-header {
            text-align: center;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .header, .section-header_b {
            text-align: center;
            font-weight: bold;
            margin: 0 auto 10px auto;
        }

        .faculty {
            display: inline-block;
            border: 1px solid #000;
            padding: 2px 5px;
        }

        .notes, .section-a {
            margin-top: 5px;
            border: 1px solid #000;
            padding: 10px;
            margin-bottom: 10px;
        }

            .notes p, .section-a p {
                margin: 5px 0;
            }

        .form-details {
            display: flex;
            justify-content: space-between;
        }

            .form-details table {
                width: 70%;
                border-collapse: collapse;
            }

            .form-details table, .form-details th, .form-details td {
                border: 1px solid #000;
                padding: 5px;
            }

        .photo-box {
            width: 25%;
            border: 1px solid #000;
            height: 180px;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            background-color: #e0e0e0;
        }

            .photo-box::before {
                content: "✖";
                position: absolute;
                font-size: 60px;
                color: red;
                font-weight: bold;
            }

        .footer {
            text-align: right;
            margin-top: 10px;
        }

        table {
            border: 1px solid black;
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            border: 1px solid black;
            padding: 4px 8px;
            vertical-align: middle;
        }

        .photo-cell {
            width: 140px;
            height: 180px;
            text-align: center;
        }

            .photo-cell img {
                width: 100%;
                height: auto;
                max-height: 180px;
            }

        .bold {
            font-weight: bold;
        }

        .with-border {
            border: 2px solid #2196F3;
        }
        /* No border for these cells */
        .no-border {
            border: none;
        }

        .input-row {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

            .input-row label {
                width: 300px;
            }

            .input-row input[type="text"],
            .input-row input[type="email"] {
                width: 300px;
                padding: 5px;
            }

        .checkbox-group {
            display: flex;
            gap: 20px;
        }

        .note {
            font-size: 12px;
            font-style: italic;
            margin-top: 5px;
        }

        .main-box {
            border: 1.5px solid #333;
            margin: 30px auto;
            padding: 18px 20px 10px 20px;
            max-width: 800px;
            background: #fff;
        }

        h2 {
            text-align: center;
            font-size: 1.18em;
            margin-bottom: 2px;
            margin-top: 0;
        }

        h3 {
            text-align: center;
            font-size: 1em;
            margin-top: 0;
            margin-bottom: 12px;
            font-weight: normal;
        }

        .instructions {
            font-size: 0.97em;
            margin-bottom: 16px;
            text-align: justify;
        }

        .voc-table {
            width: 100%;
            border-collapse: collapse;
            margin: 18px 0 10px 0;
        }

            .voc-table td, .voc-table th {
                border: solid 1px;
                padding: 3px 6px;
                font-size: 1em;
                vertical-align: middle;
            }

                .voc-table td.checkbox-cell {
                    width: 28px;
                    text-align: center;
                }

                .voc-table td.subject-label {
                    text-align: left;
                    white-space: nowrap;
                }

                .voc-table td.code {
                    width: 40px;
                    text-align: left;
                    color: #222;
                }

        .signature-row {
            margin-top: 18px;
            display: flex;
            justify-content: space-between;
        }

        .signature-box {
            border: 1.5px solid #333;
            width: 100%;
            height: 38px;
            margin-top: 0;
            margin-bottom: 0;
            display: flex;
            align-items: flex-end;
            justify-content: center;
            font-size: 0.97em;
            background: #fff;
        }

        .signature-label {
            text-align: center;
            font-size: 0.97em;
            margin-top: 2px;
        }

        .principal-section {
            margin-top: 18px;
            display: flex;
            justify-content: flex-end;
        }

        .principal-box {
            border: 1.5px solid #333;
            width: 250px;
            height: 115px;
            margin-left: auto;
            background: #fff;
            display: flex;
            align-items: flex-end;
            justify-content: center;
            font-size: 0.97em;
        }

        .note-box {
            border: 1px solid #aaa;
            background: #f9f9f9;
            font-size: 0.98em;
            padding: 7px 9px;
            margin-top: 14px;
            margin-bottom: 8px;
        }

        .footer {
            text-align: right;
            font-size: 0.93em;
            color: #444;
            margin-top: 6px;
        }

        .q33-box {
            border: 2px solid #000;
            padding: 16px;
            margin: 20px 0;
        }

        .subject-group {
            margin-bottom: 20px;
            padding: 10px;
            border: 1px solid #ccc;
        }

            .subject-group h4 {
                margin-top: 0;
            }

        #section_1733 {
            margin-top: 20px;
            margin-bottom: -10px;
        }



        @media print {



            .container {
                border: none;
            }
           .page3{
            margin-top:60px;
        }
            

            .page {
                page-break-after: always;
            }

                .page:last-child {
                    page-break-after: auto;
                }
        }
         .btn {
     padding: 10px 20px;
     background-color: #3f51b5; /* Fluree-style blue */
     color: #fff;
     font-size: 16px;
     font-weight: 500;
     border: none;
     border-radius: 6px;
     cursor: pointer;
     transition: all 0.3s ease;
     box-shadow: 0 4px 8px rgba(63, 81, 181, 0.2);
 }

     .btn:hover {
         background-color: #303f9f;
         box-shadow: 0 6px 12px rgba(63, 81, 181, 0.3);
     }

     .btn:active {
         background-color: #1a237e;
         transform: scale(0.98);
     }

     .btn:disabled {
         background-color: #ccc;
         cursor: not-allowed;
     }
    </style>
    <style type="text/css" media="print">
        #btnPrint {
            display: none !important;
        }
        .page3{
            margin-top:60px;
        }

        #page3 table {
            font-size: 12px; /* Smaller text */
        }

        .q33-box {
            border: 1px solid #000;
            padding: 10px;
            margin: 10px 0;
        }

        /* .notes, .section-a {
                padding: 10px;
                margin-bottom: 20px;
            }

            #section_1733_table {
                margin-top: -15px;
            }

            .container {
                padding: 10px;
            }*/
    </style>
</head>
<body>
    <form id="form1" runat="server">
         <div class="print-btn-container" style="text-align: center !important;margin-bottom: 10px;">
            <%-- <asp:Button ID="btnPrint" runat="server" Text="PDF" OnClientClick="window.print(); return false;" />--%>
             <a href="DwnldExamForm.aspx" class="btn btn-primary no-print" style="text-decoration: none !important;">Back</a>
            <asp:Button ID="btnPrint" runat="server" Text="PDF" OnClick="btnPrint_Click" CssClass="btn"/>
          
        </div>

        <asp:Repeater ID="rptStudents" runat="server" OnItemDataBound="rptStudents_ItemDataBound">
            <ItemTemplate>

                <div class="container">
                    <div class="lineheart_a">
                        <div class="page" id="page1">
                            <div class="form-header">
                                <div class="board-title">BIHAR SCHOOL EXAMINATION BOARD, PATNA</div>
                                <div class="exam-title"></div>

                                <div class="faculty-box">
                                    Faculty - <span><%# Eval("FacultyName") %></span>
                                </div>

                                <div class="hindi-line">
                                    <strong>Online Examination Application Form for Intermediate Annual Examination, 2026</strong>
                                    <p>(Only for Regular & Private student's registered for Session-2024-26)</p>
                                </div>

                                <div class="session-line">
                                    <u>Examination FORM-    SESSION:2024-26</u>
                                </div>
                            </div>

                            <div class="notes">

                                <p><strong>नोट:-</strong>(i) सूचीकरण हेतु आपके द्वारा दी गई सूचनाओं के आधार पर आपका सूचीकरण विवरण इस प्रपत्र के खण्ड 'A' (क्रमांक- 1 से 17) में अंकित है।</p>
                                <p>(ii) खण्ड 'A' (क्रमांक- 1 से 17) के अंकित विवरणों में विद्यार्थी द्वारा किसी भी प्रकार का कोई छेड़-छाड़/परिवर्तन नहीं किया जाएगा। अर्थात् क्रमांक- 1 से 17 तक में विद्यार्थी द्वारा कुछ भी नहीं लिखा जाएगा।</p>
                                <p>(iii) विद्यार्थी द्वारा इस आवेदन प्रपत्र में मात्र खण्ड 'B' के बिन्दुओं को ही भरा जाएगा।</p>
                            </div>
                            <div class="section-a">
                                <div>
                                    <p class="section-header  form-header ">खण्ड 'A'</p>


                                </div>

                                <p><strong>नोट:-</strong>खण्ड 'A' (क्रमांक- 1 से 17) के अंकित विवरणों में विद्यार्थी द्वारा किसी भी प्रकार का कोई छेड़-छाड़/परिवर्तन नहीं किया जाएगा। अर्थात् क्रमांक- 1 से 17 तक में विद्यार्थी द्वारा कुछ भी नहीं लिखा जाएगा।</p>
                            </div>

                            <table>
                                <tr>
                                    <td class="">1.Registration no. & Year .</td>
                                    <td colspan="4"><%# Eval("RegistrationNo") %></td>

                                    <td rowspan="9" class="photo-cell">
                                        <img src='<%# ResolveUrl(Eval("StudentPhotoPath").ToString()) %>' alt="Student Photo" /><br />
                                        <img src='<%# ResolveUrl(Eval("StudentSignaturePath").ToString()) %>' alt="Student Signature" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="no-border">2.BSEB Unique Id.</td>
                                    <td colspan="4"><%# Eval("UniqueNo") %></td>
                                </tr>
                                <tr>
                                    <td class="no-border">3.Student's Category</td>
                                    <td class="bold" colspan="4"><%# Eval("CategoryName") %></td>
                                </tr>
                                <tr>
                                    <td class="no-border">4. College/+2 School Code</td>
                                    <td colspan="4"><%# Eval("CollegeCode") %></td>
                                </tr>
                                <tr>
                                    <td class="no-border">5. College/+2 School Name</td>
                                    <td colspan="4"><%# Eval("CollegeName") %></td>
                                </tr>
                                <tr>
                                    <td class="no-border">6. District Name</td>
                                    <td colspan="4"><%# Eval("DistrictName") %></td>
                                </tr>
                                <tr>
                                    <td class="no-border">7. Student’s Name</td>
                                    <td colspan="4"><%# Eval("StudentName") %></td>
                                </tr>
                                <tr>
                                    <td class="no-border">8. Mother’s Name</td>
                                    <td colspan="4"><%# Eval("MotherName") %></td>
                                </tr>
                                <tr>
                                    <td class="no-border">9. Father’s Name</td>
                                    <td colspan="4"><%# Eval("FatherName") %></td>
                                </tr>
                                <tr>
                                    <td class="no-border">10. Date of Birth</td>
                                    <td class="bold" colspan="4"><%# Eval("dob") %></td>
                                </tr>
                                <tr>
                                    <td class="no-border">11. Matric/Class X Passing Board's Name</td>
                                    <td colspan="4"><%# Eval("MatricBoardName") %></td>
                                    <td class="no-border"></td>
                                </tr>
                                <tr>
                                    <td class="no-border">12. Matric/Class X Board’s Roll Code</td>
                                    <td colspan="4"><%# Eval("MatricRollCode") %></td>
                                    <td class="no-border"></td>
                                </tr>
                                <tr>
                                    <td class="no-border">Roll Number</td>
                                    <td colspan="4"><%# Eval("MatricRollNumber") %></td>
                                    <td class="no-border"></td>
                                </tr>
                                <tr>
                                    <td class="no-border">Passing Year</td>
                                    <td colspan="4"><%# Eval("MatricPassingYear") %></td>
                                    <td class="no-border"></td>
                                </tr>
                                <tr>
                                    <td class="no-border">13. Gender</td>
                                    <td colspan="4"><%# Eval("Gender") %></td>
                                    <td class="no-border"></td>
                                </tr>
                                <tr>
                                    <td class="no-border">14. Caste Category</td>
                                    <td colspan="4"><%# Eval("CasteCategory") %></td>
                                    <td class="no-border"></td>
                                </tr>
                                <tr>
                                    <td class="no-border">15. Differently abled</td>
                                    <td colspan="2">
                                        <%# Eval("DifferentlyAbled") %>
                                    </td>
                                    <td colspan="2">Specify (if yes)</td>
                                    <td colspan="1">
                                        <%--<%# Eval("SpecifyReason") %>--%>
                                    </td>
                                </tr>


                                <tr>
                                    <td class="no-border">16. Nationality</td>
                                    <td><%# Eval("Nationality") != null && Eval("Nationality").ToString() == "Indian" ? "Indian" : "" %></td>
                                    <td>Others</td>
                                    <td><%# Eval("Nationality") != null && Eval("Nationality").ToString() == "Other than Indian" ? "Other than Indian" : "" %></td>
                                    <td>(As per Rule)</td>
                                </tr>

                                <tr>
                                    <td class="no-border">17. Religion</td>
                                    <td colspan="4"><%# Eval("Religion") %></td>
                                    <td class="no-border"></td>
                                </tr>
                            </table>


                        </div>
                        <div class="page" id="page2">
                            <div class="section" id="section_1733">
                                <div class="section-header">

                                    <div class="section-a">
                                        <p class="section-header_b faculty">खण्ड - 'B'</p>
                                        <p>(विद्यार्थी द्वारा मात्र खण्ड 'B' के बिन्दुओं (क्रमांक 18 से 34 तक) को ही भरा जाएगा)</p>
                                    </div>
                                </div>
                            </div>
                            <table id="section_1733_table">
                                <tr>
                                    <td>
                                        <div class="input-row" style="display: block !important;">
                                            <label><strong>18. कृपया "आधार नंबर" अंकित करें। </strong></label>
                                            <p>(यदि विद्यार्थी का "आधार नम्बर" आवंटित नहीं हुआ है, तो विद्यार्थी के द्वारा इस आशय की घोषणा क्रमांक-19 में की जानी आवश्यक होगी कि उन्हें "आधार नंबर" आवंटित नहीं हुआ है)</p>
                                        </div>
                                        <div class="note" style="font-style: normal;">
                                            PLEASE MENTION "AADHAR NUMBER".<br>
                                            (If student has not enrolled in Aadhar and doesn't have "Aadhar number" then he/she is required to submit declaration in Sl. No. 19 that he/she has not been enrolled in Aadhar and has not got "Aadhar number".)
                                        </div>
                                    </td>
                                    <td>
                                        <div class="input-row">
                                            <%# Eval("AadharNumber") %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <div class="section-a">
                                <label>
                                    19. यदि विद्यार्थी के द्वारा उपयुक्त क्रमांक-18 में "आधार नंबर" अंकित नहीं किया गया है, तो उनके द्वारा निम्नांकित घोषणा की जायेगी:-<br>
                                    <strong>(कृपया नोट करें कि यहाँ किसी भी तरह की गलत घोषणा के लिए विद्यार्थी के विरुद्ध कार्यवाही की जा सकेगी तथा आधार
                                नंबर नहीं होने के संबंध में इस किया/गलत घोषणा के कारण उनका आवेदन अमान्य/निरस्त किया जा सकता है)</strong>
                                </label>
                                <div class="note" style="text-decoration: underline; font-style: normal;">
                                    <strong>घोषणा:- मैं, उपर्युक्त द्वारा घोषित करता हूँ कि मैंने "आधार नंबर" आवंटित करने के लिए आवेदन नहीं किया है तथा मुझे "आधार नंबर" आवंटित नहीं हुआ है। मैं यह भी समझता हूँ कि मेरे द्वारा की गई इस किया/गलत घोषणा के आधार पर मेरा अभ्यर्थन रद्द किया जा सकता है।</strong>
                                    <p>If student has not given "Aadhar number" in Sl. No. <strong>18</strong> above, then following declaration should be given by student:-</p>
                                    <p>
                                        <strong>(Please note that any WRONG DECLARATION made here, may invite action against the student and his/her candidature may be cancelled due to making false declaration about non-allotment of "Aadhar number")
DECLARATION: – I hereby declare that I have not enrolled in Aadhar and have not got any "Aadhar number". I also understand that any false declaration made by me in this regard may have consequence of cancellation of my candidature.</strong>
                                    </p>
                                </div>

                                <div class="input-row" style="margin-top: 35px;">
                                    <label>
                                        Signature of student<br>
                                        विद्यार्थी का हस्ताक्षर 

                                    </label>
                                    <input type="text" placeholder="Signature">
                                </div>
                            </div>

                            <div class="section section-a lineheart_b">
                                <div class="input-row">
                                    <label>20. Area where the institution is situated <strong>(कृपया ✓ करें)</strong></label>
                                    <div class="checkbox-group">
                                        <label>
                                            <input type="checkbox" disabled="disabled" <%# Eval("AreaName") != null && Eval("AreaName").ToString() == "Rural" ? "checked" : "" %> />
                                            Rural
                                        </label>
                                        <label>
                                            <input type="checkbox" disabled="disabled" <%# Eval("AreaName") != null && Eval("AreaName").ToString() == "Urban" ? "checked" : "" %> />
                                            Urban
                                        </label>
                                    </div>
                                </div>


                                <div class="input-row">
                                    <label>21. Sub-Division (where the institution is situated)</label>
                                    <%# Eval("SubDivisionName") %>
                                </div>

                                <div class="input-row">
                                    <label>22. Mobile No.</label>
                                    <div class="" style="border: 1px solid; padding: 3px 40px;">

                                        <%# Eval("MobileNo") %>
                                    </div>
                                    <label></label>
                                    <label>23. E-Mail Id</label>
                                    <div class="" style="border: 1px solid; padding: 3px 40px;">

                                        <%# Eval("EmailId") %>
                                    </div>
                                </div>

                                <div class="input-row">
                                    <label>24. Student’s Name in Hindi</label>
                                    <input type="text">
                                </div>

                                <div class="input-row">
                                    <label>25. Mother’s Name in Hindi</label>
                                    <input type="text">
                                </div>

                                <div class="input-row">
                                    <label>26. Father’s Name in Hindi</label>
                                    <input type="text">
                                </div>

                                <div class="input-row">
                                    <label>27. Student’s Address</label>
                                    <%# Eval("StudentAddress") %>
                                </div>

                                <div class="input-row">
                                    <label>28. Marital Status (वैवाहिक स्थिति) (Please tick √)</label>
                                    <div class="checkbox-group">


                                        <label>
                                            <input type="checkbox" disabled="disabled"
                                                <%# Eval("MaritalStatus") != null && Eval("MaritalStatus").ToString().ToLower() == "married" ? "checked" : "" %> />
                                            Married (If Married, write word MARRIED in the box)
                                        </label>
                                        <label>
                                            <input type="checkbox" disabled="disabled"
                                                <%# Eval("MaritalStatus") != null && Eval("MaritalStatus").ToString().ToLower() == "unmarried" ? "checked" : "" %> />
                                            Unmarried (If Unmarried, write word UNMARRIED in the box)
                                        </label>

                                    </div>
                                </div>

                                <div class="input-row">
                                    <label>29. Student’s Bank A/C No.*</label>
                                    <%# Eval("StudentBankAccountNo") %>
                                    <label></label>
                                    <label>30. IFSC Code*</label>
                                    <%# Eval("IFSCCode") %>
                                </div>

                                <div class="note">
                                    (Sl.No. 29, 30 and 31 are not compulsory, all other fields are compulsory)
                                </div>

                                <div class="input-row">
                                    <label>31. Bank & Branch Name*</label>
                                    <%# Eval("BankBranchName") %>
                                </div>

                                <div class="input-row">
                                    <label>32. Two identification marks of student</label>
                                                                       <div class="" style="border: 1px solid; padding: 0px 40px;">

                                        i.
                                <%# Eval("IdentificationMark1") %>

                                        <br />


                                        ii.
                                <%# Eval("IdentificationMark2") %>
                                   </div>


                                </div>

                                <div class="input-row">
                                    <label>33. Medium (language) of appearing in examination (परीक्षा में उपस्थित होने का माध्यम) (Please tick √)</label>

                                    <div class="checkbox-group">

                                        <label>
                                            <input type="checkbox" disabled="disabled"
                                                <%# Eval("MediumName") != null && Eval("MediumName").ToString().ToLower() == "hindi" ? "checked" : "" %> />
                                            Hindi
                                        </label>
                                        <label>
                                            <input type="checkbox" disabled="disabled"
                                                <%# Eval("MediumName") != null && Eval("MediumName").ToString().ToLower() == "english" ? "checked" : "" %> />
                                            English
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div id="pagewrap">
                        <div class="page page3" id="page3">
                            <div class="q33-box">
                                <div class="section-title" style="padding-left: 5px;"><strong>34. Subject details with their numerical codes:-</strong></div>

                                <div class="section-title" style="text-align: center;">
                                    <strong>Compulsory Subject Group (Total 200 Marks)</strong>
                                    <p>(Select (&#10003;) one subject from each group - each subject: 100 Marks)</p>
                                </div>
                                <table>
                                    <tr>
                                        <th colspan="2">Compulsory Subject Group-1 (100 Marks)<br>
                                            (Select any one subject)</th>
                                        <th colspan="2">Compulsory Subject Group-2 (100 Marks)<br>
                                            (Select any one subject, which is not selected under Compulsory Subject Group-1)</th>
                                    </tr>
                                    <asp:Repeater ID="rptCompulsorySubjectsCombined" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                 <td>
                                                     <%# Eval("Group1SubjectName") %>
                                                 </td>
                                                 <td>
                                                     <%# Eval("Group1CheckboxHtml") %>
                                                 </td>
                                                 <td>
                                                     <%# Eval("Group2SubjectName") %>
                                                 </td>
                                                 <td>
                                                     <%# Eval("Group2CheckboxHtml") %>
                                                 </td>
                                             </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </table>
                            </div>

                            <div class="q33-box">
                                <div class="section-title" style="text-align: center;">
                                    <strong>Elective Subject Group (Total 300 Marks)</strong>
                                    <p>(Select (&#10003;) any three subjects - each 100 Marks)</p>
                                </div>
                                <table>
                                    <asp:Repeater ID="rptElectiveSubjects" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("Name1") %></td>
                                                 <td>
                                                     <%# Eval("Checkbox1Html") %>
                                                 </td>
                                                 <td><%# Eval("Name2") %></td>
                                                 <td>
                                                     <%# Eval("Checkbox2Html") %>
                                                 </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>

                                    <asp:Repeater ID="rptVocElectiveSubjects" runat="server" Visible="false">
                                        <ItemTemplate>
                                            <tr>
                                                <!-- Subject 1 -->
                                                <td>
                                                    <%# Eval("Name1") %>
                                                    
                                                </td>
                                                <td>
                                                   <span><%# Eval("Code1") %></span> <%# Eval("Checkbox1Html") %>
                                                </td>
                                                <!-- Subject 2 -->
                                                <td>
                                                    <%# Eval("Name2") %>
                                                    
                                                </td>
                                                <td>
                                                  <span><%# Eval("Code2") %></span>  <%# Eval("Checkbox2Html") %>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>

                                </table>
                            </div>

                            <div class="q33-box">
                                <div class="section-title" style="text-align: center;">
                                    <strong>Additional Subject Group (100 Marks)</strong>

                                    <p style="font-size: 89%;"><strong>i.</strong>The student who desires to keep additional subject, must select (✓) any one subject from following subject group which he/she has not selected under compulsory subject group-1 or compulsory subject group-2 or elective subject group.</p>
                                    <p style="font-size: 89%;">
                                        <strong>ii.</strong> The student who does not want to keep additional subject, need not to select any subject under this subject group.
                    The student who does not want to keep additional subject, need not to select any subject under this subject group.
                                    </p>

                                </div>
                                <table>
                                    <asp:Repeater ID="rptAdditionalSubjects" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                  <%-- Column 1 --%>
                                              <td><%# Eval("Name1") %></td>
                                              <td><%# Eval("Checkbox1Html") %></td>
                                              <%-- Column 2 --%>
                                              <td><%# Eval("Name2") %></td>
                                              <td><%# Eval("Checkbox2Html") %></td>
                                              <%-- Column 3 --%>
                                              <td><%# Eval("Name3") %></td>
                                              <td><%# Eval("Checkbox3Html") %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </table>
                                <div class="note">
                                    <b>Note:</b> Computer Science, Yoga & Phy. Edu. and Multimedia & Web.Tech. cannot be interchanged/swapped with any other subject.

                                </div>
                            </div>
                        </div>

                        <div class="page" id="page4">
                            <asp:Panel ID="pnlVocational" runat="server" Visible="false">
                                <div class="q33-box">

                                    <h2>Vocational Trade Group (100 Marks)</h2>
                                    <h3>(For students of Science, Commerce & Arts faculties)</h3>

                                    <div class="instructions">
                                        (i) विज्ञान, वाणिज्य एवं कला संकायों के विद्यार्थियों के लिए सत्र 2022-24 से राज्य के सभी जिलों के कुछ चिन्हित +2 विद्यालय/विद्यालयों में विभिन्न व्यावसायिक ट्रेंड के पठन-पाठन की शुरुआत की गई है, जिनकी सूची समिति के पोर्टल/वेबसाइट पर प्रदर्शित की गई है। व्यावसायिक ट्रेंड का पठन-पाठन अनिवार्य (Compulsory), ऐच्छिक (Elective) एवं अतिरिक्त (Additional) विषय संरचना के अलावा होगा।<br>
                                        (ii) उपरोक्त +2 विद्यालयों, जिनकी सूची समिति के पोर्टल/वेबसाइट पर प्रदर्शित की गई है, के वैसे विद्यार्थी, जिन्हें व्यावसायिक ट्रेंड आवंटित किया गया है, के द्वारा इस ट्रेंड समूह में से किसी एक ट्रेंड का चयन किया जाता एवं उसकी परीक्षा (सैद्धान्तिक एवं प्रायोगिक) में सम्मिलित होना अनिवार्य है। यद्यपि कि, इसके प्राप्तांक की गणना वार्षिक निर्णय हेतु नहीं की जाएगी तथा इसे किसी अन्य विषय के प्राप्तांक से परिवर्तित (Interchange/Swap) नहीं किया जाएगा।<br>
                                        (iii) राज्य/जिला के अन्य +2 विद्यालय, जो व्यावसायिक ट्रेंड का पठन-पाठन हेतु चिन्हित नहीं हैं, के विद्यार्थियों द्वारा इस ट्रेंड समूह में से किसी ट्रेंड का चयन नहीं किया जाएगा।

                                    </div>

                                    <table class="voc-table">
                                        <asp:Repeater ID="rptVocationalAdditionalSubjects" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="subject-label"><%# Eval("SubjectPaperName") %></td>
                                                     <td class="code">(<%# Eval("SubjectPaperCode") %>)</td>
                                                     <td class="checkbox-cell">
                                                         <%# Eval("CheckboxHtml") %>
                                                     </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>

                                    </table>

                                </div>
                            </asp:Panel>
                            <div class="note-box">
                                प्रमाणित किया जाता है कि इस आवेदन पत्र में दी गई सूचना पूरी तरह से सही एवं शुद्ध हैं और इसमें कहीं पर भी किसी प्रकार के संशोधन की आवश्यकता नहीं है। जो भी सुधार एवं संशोधन थे, सब करा लिए गए हैं।

                            </div>

                            <div class="signature-row">
                                <div>
                                    <div class="signature-box"></div>
                                    <div class="signature-label">Signature of Parent/Guardian</div>
                                </div>
                                <div>
                                    <div class="signature-box"></div>
                                    <div class="signature-label">Student's Signature in Hindi</div>
                                </div>
                                <div>
                                    <div class="signature-box"></div>
                                    <div class="signature-label">Student's Signature in English</div>
                                </div>
                            </div>

                            <div class="note-box">
                                प्रमाणित किया जाता है कि ऊपर दिए गए सभी विवरण का मिलान महाविद्यालय/+2 विद्यालय के सभी अभिलेखों से पूर्णरूपेण कर लिया गया है। तत्संबंध में उक्त विद्यार्थी का सूचीकरण/अनुमति आवेदन पत्र स्वीकार किया जाए।

                            </div>

                            <div class="principal-section">
                                <div>
                                    <div class="principal-box"></div>
                                    <div class="signature-label">Signature &amp; seal of Principal</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

    </form>
</body>
</html>
