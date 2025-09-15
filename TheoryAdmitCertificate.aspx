﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TheoryAdmitCertificate.aspx.cs" Inherits="TheoryAdmitCertificate" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Theory Admit Certificate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans Devanagari', 'Mangal', 'Arial', sans-serif;
        }

        .container {
            padding: 40px;
            margin-top: 20px;
        }

        .header {
            text-align: center;
            margin-bottom: 20px;
        }

        .logo {
            max-width: 130px;
            margin-bottom: 10px;
        }

        .photo {
            width: 120px;
            height: 150px;
            border: 1px solid #ccc;
            margin-top: 10px;
        }

        .table-details {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

            .table-details th, .table-details td {
                border: 1px solid black;
                padding: 8px;
                text-align: center;
            }

        .instructions {
            margin-top: 20px;
            font-size: 20px;
        }

        .signature {
            text-align: right;
            margin-top: 30px;
        }

        @media print {
            .container {
                width: 100%;
                max-width: 100%;
                padding: 10mm 12mm;
                margin: 0 auto;
                box-sizing: border-box;
                page-break-inside: avoid;
            }

            @page {
                size: A4 portrait;
                margin: 10mm 12mm 10mm 12mm; /* Top Right Bottom Left */
            }

            body {
                margin: 0;
                padding: 0;
                font-size: 14px !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            img {
                max-width: 100%;
                height: auto;
            }

            .btn, .no-print {
                display: none !important;
            }
        }

        /*@media print {
            body {
                margin: 0;
                padding: 0;
                font-size: 17px !important;*/ /* Increased font size */
        /*line-height: 1.4;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            .container, .table-details, .subjects-table, .row, .table, .header, .instructions {
                font-size: inherit !important;
            }


                .subjects-table th, .subjects-table td {
                    padding: 10px 12px !important;
                    line-height: 2 !important;
                }

            @page {
                size: A4 portrait;
                margin: 10mm 12mm 10mm 12mm;*/ /* Top, Right, Bottom, Left */
        /*}

            .btn, .no-print {
                display: none !important;
            }

            .container {
                width: 100%;
                border: 1px solid #000;
                margin: 0 auto;
                padding: 15px;*/ /* Add inner spacing */
        /*box-sizing: border-box;
                page-break-inside: avoid;
            }

            .table-details, .subjects-table {
                font-size: 16px;*/ /* Slightly larger */
        /*}

            .row, .table, .table th, .table td, .header, .instructions, .signature {
                page-break-inside: avoid;
                break-inside: avoid;
            }

            img {
                max-width: 100%;
                height: auto;
            }

            hr {
                border-top: 1px solid black !important;
            }

            .custom-hr {
                margin: 1rem 0;
                color: inherit;
                border: none;
                border-top: 2px solid #000;
                opacity: 1;
            }
        }*/
    </style>
</head>
<body>
    <form runat="server" id="form1">
        <div class="text-center mt-4 mb-5">
            <a href="Theoryadmitcard.aspx" class="btn btn-primary no-print" style="text-decoration: none !important;">Back</a>
            <button type="button" onclick="generatePDF()" class="btn btn-primary no-print">Download PDF</button>
        </div>
        <asp:Repeater ID="rptStudents" runat="server" OnItemDataBound="rptStudents_ItemDataBound">
            <ItemTemplate>
                <div class="container" id="admitCard">
                    <div class="header">
                        <div class="row">
                            <div class="col-md-3">
                                <img src="assets/img/bsebimage.jpg" alt="Bihar Board Logo" class="logo" />
                            </div>
                            <div class="col-md-6 text-center">
                                <div class="title">
                                    <strong>बिहार विद्यालय परीक्षा समिति</strong><br />
                                    <strong>BIHAR SCHOOL EXAMINATION BOARD</strong>
                                </div>
                                <div class="sub-title mt-2">
                                    <strong>
                                        <asp:Label ID="lblExamTitleHindi" runat="server" CssClass="hindi-title" /></strong>
                                    <br />
                                    <strong>
                                        <asp:Label ID="lblExamTitle" runat="server" CssClass="english-title" /><br />
                                    </strong>
                                    <strong>सैद्धान्तिक परीक्षा का प्रवेश-पत्र</strong><br />
                                    <strong>Admit Card of Theory Examination</strong>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <asp:PlaceHolder ID="phFaculty" runat="server">
                                    <asp:Label runat="server" ID="lblFacultyHindi" />
                                    <br />
                                </asp:PlaceHolder>
                                <label style="margin-left: 37px;"><strong>FACULTY:</strong> <%# Eval("FacultyName") %></label>
                            </div>



                            <%-- <div class="col-md-3">
                           
                            <asp:Literal ID="litFacultyLabels" runat="server" />
                        </div>--%>
                        </div>
                    </div>

                    <table style="width: 105%; border-collapse: collapse;">
                        <tr>
                            <td style="width: 75%;">
                                <table style="width: 100%; font-size: 14px;">

                                    <asp:HiddenField ID="hfFacultyId" runat="server" Value='<%# Eval("FacultyId") %>' />
                                    <tr>
                                        <td><strong>* BSEB UNIQUE Id:</strong></td>
                                        <td><%# Eval("UniqueNo") %></td>
                                    </tr>
                                    <tr>
                                        <td><strong>कॉलेज/+2 स्कूल का नाम:</strong></td>
                                        <td><%# Eval("CollegeName") %></td>
                                    </tr>
                                    <tr>
                                        <td><strong>परीक्षार्थी का नाम:</strong></td>
                                        <td><%# Eval("StudentName") %></td>
                                    </tr>
                                    <tr>
                                        <td><strong>माता का नाम:</strong></td>
                                        <td><%# Eval("MotherName") %></td>
                                    </tr>
                                    <tr>
                                        <td><strong>पिता का नाम:</strong></td>
                                        <td><%# Eval("FatherName") %></td>
                                    </tr>
                                    <tr>
                                        <td><strong>वैवाहिक स्थिति:</strong></td>
                                        <td><%# Eval("MaritalStatus") %></td>
                                    </tr>
                                    <tr>
                                        <td><strong>परीक्षार्थी का आधार नं:</strong></td>
                                        <td><%# Eval("AadharNo") %></td>
                                        <td><strong>दिव्यांग कोटि:</strong></td>
                                        <td><%# Eval("Disability") != DBNull.Value && Convert.ToBoolean(Eval("Disability")) ? "YES" : "NO" %></td>

                                    </tr>
                                    <tr>
                                        <td><strong>सूचीकरण संख्या/वर्ष:</strong></td>
                                        <td><%# Eval("RegistrationNo") %></td>
                                        <td><strong>परीक्षार्थी की कोटि:</strong></td>
                                        <td><%# Eval("ExamTypeName") %></td>
                                    </tr>
                                    <tr>
                                        <td><strong>रौल कोड:</strong></td>
                                        <td><%# Eval("RollCode") %></td>
                                        <td><strong>रौल क्रमांक:</strong></td>
                                        <td><%# Eval("RollNumber") %></td>
                                        <td><strong>लिंग:</strong></td>
                                        <td><%# Eval("Gender") %></td>
                                    </tr>
                                    <tr>
                                        <td><strong>परीक्षा केंद्र का नाम:</strong></td>
                                        <%-- <td colspan="5"><%# Eval("ExamCenter") %></td>--%>
                                        <td colspan="5"><%# Eval("TheoryExamCenterName") %></td>

                                    </tr>
                        </tr>
                    </table>
                    </td>

                            <!-- Right side: photo -->
                    <%-- <td style="width: 25%; text-align: center; vertical-align: top;">
                    <div style="border: 1px solid black; padding: 5px; display: inline-block;">
                        <img src='<%# Eval("StudentPhotoPath") %>' alt="Photo" style="width: 100%; max-width: 160px; height: auto;">
                    </div>
                    <div style="margin-top: 10px;">
                        <img src='<%# Eval("StudentSignaturePath") %>' alt="Signature" style="width: 100%; max-width: 180px; height: auto;">
                    </div>
                </td>--%>


                    <td style="width: 25%; text-align: center; vertical-align: top;">
                        <div style="border: 1px solid black; padding: 5px; display: inline-block;">
                            <img src='<%# ResolveUrl(Eval("StudentPhotoPath").ToString()) %>' alt="Photo" style="width: 100%; max-width: 160px; height: auto;" />
                        </div>
                        <div style="margin-top: 10px;">
                            <img src='<%# ResolveUrl(Eval("StudentSignaturePath").ToString()) %>' alt="Signature" style="width: 100%; max-width: 180px; height: auto;" />
                        </div>
                    </td>

                    </tr>
               </table>

                <table class="table table-details text-center align-middle" style="font-size: 14px; border: 2px solid #000;">
                    <thead>
                        <tr>
                            <%--<th colspan="7">सैद्धान्तिक वार्षिक परीक्षा के विषय (निरधारित परीक्षा कार्यक्रम सहित)</th>--%>
                            <th colspan="7">
                                <asp:Label ID="lblExamSubjectHindi" runat="server" />
                            </th>

                        </tr>
                        <tr>
                            <th rowspan="2"></th>
                            <th rowspan="2"></th>
                            <th rowspan="2">विषय कोड<br>
                                (संख्यात्मक)</th>
                            <th rowspan="2">विषय का नाम</th>
                            <th rowspan="2">परीक्षा की तिथि</th>
                            <th rowspan="2">पाली</th>
                            <th rowspan="2">परीक्षा का समय</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td rowspan="2">अनिवार्य विषय<br>
                                (Compulsory Subjects)</td>
                            <td>भाषा विषय-1</td>
                            <td>
                                <%# Eval("CompulsorySubject1Code") %>
                            </td>
                            <td>
                                <%# Eval("CompulsorySubject1Name") %></td>
                            <td><%# Eval("CompulsorySubject1Date") %></td>
                            <td><%# Eval("CompulsorySubject1Shift") %></td>
                            <td><%# Eval("CompulsorySubject1Time") %></td>

                        </tr>
                        <tr>
                            <td>भाषा विषय-2</td>
                            <td>
                                <%# Eval("CompulsorySubject2Code") %></td>
                            <td>
                                <%# Eval("CompulsorySubject2Name") %></td>
                            <td><%# Eval("CompulsorySubject2Date") %></td>
                            <td><%# Eval("CompulsorySubject2Shift") %></td>
                            <td><%# Eval("CompulsorySubject2Time") %></td>

                        </tr>

                        <tr>
                            <td rowspan="3">ऐच्छिक विषय<br>
                                (Elective Subjects)</td>
                            <td>ऐच्छिक विषय-1</td>
                            <td>
                                <%# Eval("ElectiveSubject1Code") %></td>
                            <td>
                                <%# Eval("ElectiveSubject1Name") %></td>
                            <td><%# Eval("ElectiveSubject1Date") %></td>
                            <td><%# Eval("ElectiveSubject1Shift") %></td>
                            <td><%# Eval("ElectiveSubject1Time") %></td>

                        </tr>
                        <tr>
                            <td>ऐच्छिक विषय-2</td>
                            <td>
                                <%# Eval("ElectiveSubject2Code") %></td>
                            <td>
                                <%# Eval("ElectiveSubject2Name") %></td>
                            <td><%# Eval("ElectiveSubject2Date") %></td>
                            <td><%# Eval("ElectiveSubject2Shift") %></td>
                            <td><%# Eval("ElectiveSubject2Time") %></td>

                        </tr>
                        <tr>
                            <td>ऐच्छिक विषय-3</td>
                            <td><%# Eval("ElectiveSubject3Code") %></td>
                            <td><%# Eval("ElectiveSubject3Name") %></td>
                            <td><%# Eval("ElectiveSubject3Date") %></td>
                            <td><%# Eval("ElectiveSubject3Shift") %></td>
                            <td><%# Eval("ElectiveSubject3Time") %></td>

                        </tr>
                        <tr>
                            <td colspan="2">अतिरिक्त विषय (Additional Subject)</td>
                            <%--<td></td>--%>
                            <td><%# Eval("AdditionalSubjectCode") %></td>
                            <td><%# Eval("AdditionalSubjectName") %></td>
                            <td><%# Eval("AdditionalSubjectDate") %></td>
                            <td><%# Eval("AdditionalSubjectShift") %></td>
                            <td><%# Eval("AdditionalSubjectTime") %></td>
                        </tr>
                        <tr>
                            <asp:PlaceHolder ID="phVocationalHeader" runat="server" Visible='<%# Eval("HasVocationalSubjects") %>'>
                                <td colspan="2">व्यावसायिक ट्रेड<br>
                                    (Vocational Trade)</td>
                                <%--<td></td>--%>
                                <td><%# Eval("VocationalSubjectCode") %></td>
                                <td><%# Eval("VocationalSubjectName") %></td>
                                <td><%# Eval("VocationalSubjectDate") %></td>
                                <td><%# Eval("VocationalSubjectShift") %></td>
                                <td><%# Eval("VocationalSubjectTime") %></td>

                            </asp:PlaceHolder>
                        </tr>
                    </tbody>
                </table>

                    <!-- ✅ SUBJECT TABLE END -->


                    <!-- Instructions and PDF button stay here, outside the Repeater -->



                    <div style="font-family: 'Noto Sans Devanagari', 'Mangal', 'Arial', sans-serif; font-size: 14px; margin-top: 65px;">

                        <!-- Signature block -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <asp:Label ID="lblExamSchoolHindi" runat="server" /><br>
                                <em>एवं मुहर</em>
                            </div>
                            <div class="col-md-6 text-end">
                                परीक्षा नियंत्रक (30मा0) 
                            </div>
                        </div>
                        <%--<hr style="border-top:var(--bs-border-width) solid black;opacity: 1;border: 2px;" />--%>
                        <hr style="border: 1px solid black !important; opacity: 1.25 !important;" />
                        <!-- Heading -->
                        <h6 class="text-center mb-3"><u>परीक्षार्थी के लिए आवश्यक निर्देश</u></h6>

                        <!-- Instructions -->
                        <ol style="font-size: small;">
                            <li>यह मूल प्रवेश पत्र केवल जाँच परीक्षा (Sent-up Examination) में उत्तीर्ण (Sent-up) छात्र/छात्रा के लिए ही मान्य है। जाँच परीक्षा में अनुत्तीर्ण अथवा अनुपस्थित छात्र/छात्रा के लिए यह मूल प्रवेश पत्र मान्य नहीं है।</li>
                            <li>प्रथम पाली के परीक्षार्थी को परीक्षा प्रारंभ होने के समय पूर्वाह्न 09:30 बजे से 30 मिनट पूर्व अर्थात् पूर्वाह्न 09:00 बजे तक तथा द्वितीय पाली के परीक्षार्थी को परीक्षा प्रारंभ होने के समय अपराह्न 02:00 बजे से 30 मिनट पूर्व अर्थात् अपराह्न 01:30 बजे तक परीक्षा भवन में प्रवेश की अनुमति दी जाएगी। विलम्ब से आने वाले परीक्षार्थी को परीक्षा भवन में प्रवेश की अनुमति नहीं मिलेगी।</li>
                            <li>परीक्षा भवन में जूता-मोजा पहन कर आना सर्वथा वर्जित है अन्यथा परीक्षा भवन में प्रवेश की अनुमति नहीं मिलेगी। परीक्षा केन्द्र में कैलकुलेटर, मोबाइल फोन, ब्लूटूथ, ईयरफोन, इलेक्ट्रॉनिक घड़ी, स्मार्ट घड़ी अथवा मैगनेटिक घड़ी या अन्य इलेक्ट्रॉनिक गैजेट्स आदि लाना/प्रयोग करना वर्जित है। परीक्षार्थी परीक्षा भवन में प्रवेश पत्र एवं पेन के अलावा कुछ भी नहीं ले जायेंगे और निर्दिष्ट स्थान/सीट पर ही बैठेंगे।</li>
                            <li>परीक्षार्थी को प्रत्येक विषय की परीक्षा के लिए एक ओ०एम०आर० उत्तर पत्रक एवं एक उत्तरपुस्तिका मिलेगी, जिस पर परीक्षार्थी का विवरण अंकित रहेगा। परीक्षार्थी ओ०एम०आर० उत्तर पत्रक एवं उत्तरपुस्तिका प्राप्त करने के उपरांत जाँच कर आश्वस्त हो लेंगे कि यह ओ०एम०आर० उत्तर पत्रक एवं उत्तरपुस्तिका उन्हीं की है। अतिरिक्त ओ०एम०आर० उत्तर पत्रक एवं उत्तरपुस्तिका नहीं दी जाएगी।</li>
                            <li>परीक्षार्थी द्वारा उत्तरपुस्तिका के कवर पृष्ठ के बायाँ भाग में केवल विषय का नाम एवं उत्तर देने का माध्यम अंकित किया जाएगा और जिस सेट कोड का प्रश्न पत्र उसे मिला है, उस प्रश्न पत्र सेट कोड को बॉक्स में अंकित करते हुए प्रश्न पत्र सेट कोड वाले गोलक को काले/नीले बॉल पेन से भरा जाएगा (प्रगाढ़ किया जाएगा)। उत्तरपुस्तिका के कवर पृष्ठ के दाहिने भाग में भी प्रश्न पत्र सेट कोड को बॉक्स में अंकित करते हुए प्रश्न पत्र सेट कोड वाले गोलक को भरा जाएगा (प्रगाढ़ किया जाएगा) एवं निर्दिष्ट स्थान में प्रश्न पत्र क्रमांक अंकित करते हुए अपना पूरा नाम एवं विषय का नाम अंकित कर परीक्षार्थी द्वारा अपना पूर्ण हस्ताक्षर किया जाएगा। उत्तरपुस्तिका के कवर पेज का मध्य भाग केवल परीक्षक के उपयोग के लिए है, अतः इस भाग में परीक्षार्थी द्वारा कुछ भी नहीं भरा जाएगा। ओ०एम०आर० उत्तर पत्रक में भी परीक्षार्थी द्वारा निर्दिष्ट स्थान में प्रश्न पत्र क्रमांक, परीक्षा केन्द्र का नाम, अपना पूर्ण हस्ताक्षर तथा प्रश्न पत्र के सेट कोड को निर्दिष्ट बॉक्स में अंकित करते हुये प्रश्न पत्र सेट कोड वाले गोलक को काले/नीले बॉल पेन से भरा जायेगा (प्रगाढ़ किया जाएगा)।</li>
                            <li>यदि उत्तरपुस्तिका में एक कार्ड करने की आवश्यकता है, तो परीक्षार्थी उत्तरपुस्तिका के अन्तिम पृष्ठ पर एक कार्ड करेंगे, परन्तु परीक्षक द्वारा उस एक कार्ड को काट/काट (x) करना अनिवार्य होगा।</li>
                            <li>उपस्थिति पत्रक (ए एवं बी) के यथा निर्दिष्ट स्थान में परीक्षार्थी द्वारा प्रत्येक विषय की परीक्षा में प्रश्न पत्र क्रमांक, ओ०एम०आर० संख्या एवं उत्तरपुस्तिका संख्या तथा निर्धारित बॉक्स में प्रश्न पत्र सेट कोड अंकित किया जाएगा एवं प्रश्न पत्र सेट कोड वाले गोले को काले/नीले बॉल पेन से भरते हुए (प्रगाढ़ करते हुए) अपना पूर्ण हस्ताक्षर किया जाएगा।</li>
                            <li>परीक्षा कक्ष में अनुचित साधन का प्रयोग करना वर्जित है। यदि कोई परीक्षार्थी अनुचित साधन का प्रयोग करते पकड़ा गया तो उसके विरुद्ध परीक्षा समिति द्वारा कठोर अनुशासनात्मक कार्रवाई की जाएगी।</li>
                            <li>परीक्षा कक्ष में एक-दूसरे से मदद लेने या देने, बातचीत करने अथवा किसी प्रकार का कदाचार अपनाने के अपराध में पकड़े गये परीक्षार्थी को परीक्षा से निष्कासित कर दिया जाएगा। उत्तरपुस्तिका एवं ओ०एम०आर० उत्तर पत्रकों पर व्हाईटनर, इरेजर, नाखून, ब्लेड आदि का इस्तेमाल करना सर्वथा वर्जित है। ऐसा पाये जाने पर कदाचार का मामला मानते हुए परीक्षाफल अमान्य (इंवलीद) कर दिया जाएगा।</li>
                            <li>परीक्षा प्रारम्भ होने से एक घण्टा के अंदर किसी भी परीक्षार्थी को परीक्षा केन्द्र से बाहर जाने की अनुमति नहीं होगी। वीक्षक को समर्पित ओ०एम०आर० उत्तर पत्रक एवं उत्तरपुस्तिका परीक्षार्थी को पुनः नहीं लौटायी जाएगी।</li>
                            <li>यदि किसी परीक्षार्थी के निर्गत प्रवेश पत्र में उसके किसी भी विवरण में शिक्षण संस्थान के प्रधान द्वारा अपने स्तर से सुधार/परिवर्तन कर दिया जाता है, तो उस सुधार को बिल्कुल मान्यता नहीं देते हुए केन्द्राधीक्षक द्वारा उस परीक्षार्थी को मात्र उसके प्रवेश पत्र, रौल शीट तथा उपस्थिति पत्र में अंकित विवरणों के आधार पर ही परीक्षा में सम्मिलित कराया जाएगा। साथ ही प्रवेश पत्र के मुद्रित विवरण में परिवर्तन करने वाले शिक्षण संस्थान के प्रधान के विरूद्ध नियमानुसार प्रशासनिक एवं कानूनी कार्रवाई की जाएगी।</li>
                        </ol>

                    </div>
            </ItemTemplate>
        </asp:Repeater>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

        <script>
            async function generatePDF() {

                const { jsPDF } = window.jspdf;
                const pdf = new jsPDF('p', 'mm', 'a4');
                const elements = document.querySelectorAll('.container');

                for (let i = 0; i < elements.length; i++) {
                    const element = elements[i];
                    const canvas = await html2canvas(element, {
                        scale: 2,
                        useCORS: true
                    });

                    const imgData = canvas.toDataURL('image/jpeg', 1.0);
                    const imgProps = pdf.getImageProperties(imgData);
                    const pdfWidth = pdf.internal.pageSize.getWidth();
                    const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;

                    if (i > 0) {
                        pdf.addPage();
                    }
                    pdf.addImage(imgData, 'JPEG', 0, 0, pdfWidth, pdfHeight);
                }

                pdf.save('TheoryAdmitCard.pdf');
            }
        </script>
    </form>
</body>
</html>
