<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DummyExamAdmitCertificate.aspx.cs" Inherits="DummyExamAdmitCertificate" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admit Card</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: none;
        }

        .container {
            padding: 30px;
            margin-top: 20px;
        }

        .header {
            text-align: center;
            margin-bottom: 20px;
        }

        .logo {
            max-width: 145px;
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


        .subjects-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            line-height: 1.4;
        }

            .subjects-table th, .subjects-table td {
                border: 1px solid #000;
                padding: 5px;
                text-align: center;
            }

          

            .subjects-table .hindi {
                font-family: 'Noto Serif Devanagari', sans-serif;
                font-size: 0.9rem;
            }

            .subjects-table td {
                vertical-align: middle;
            }

        .box {
            border: 1px solid #000;
            padding: 10px;
        }

        .sig-line {
            border: 1px solid #000;
            height: 40px;
            margin-bottom: 5px;
        }

        .section-title {
            font-weight: bold;
            text-align: center;
            margin-bottom: 5px;
        }

        ol li {
            margin-bottom: 5px;
        }

        .borderline {
            /*            border: 1px solid black;
*/ padding: 10px;
        }

        #infoDiv {
            margin-top: 20px;
            font-family: Arial, sans-serif;
            font-size: 14px;
        }

        @media print {
            body {
                margin: 0;
                padding: 0;
                font-size: 17px !important; /* Increased font size */
                line-height: 1.4;
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
                margin: 10mm 12mm 10mm 12mm; /* Top, Right, Bottom, Left */
            }

            .btn, .no-print {
                display: none !important;
            }

            .container {
                width: 100%;
                border: 1px solid #000;
                margin: 0 auto;
                padding: 15px; /* Add inner spacing */
                box-sizing: border-box;
                page-break-inside: avoid;
            }

            .table-details, .subjects-table {
                font-size: 16px; /* Slightly larger */
            }

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
        }
    </style>
</head>
<body>
    <form runat="server" id="form1">
        <div class="text-center mt-4 mb-5">
             <a href="Downloadadmitcard.aspx" class="btn btn-primary no-print" style="text-decoration: none !important;">Back</a>
            <button type="button" onclick="generatePDF()" class="btn btn-primary no-print">Download PDF</button>
            <%--   <button onclick="generatePDF()" class="btn btn-primary no-print">Download PDF</button>--%>
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

                                    <h5><strong>BIHAR SCHOOL EXAMINATION BOARD</strong></h5>
                                </div>
                                <div class="sub-title">

                                    <h5><strong>INTERMEDIATE ANNUAL EXAMINATION, 2026<br />
                                    </strong></h5>
                                    <h5><strong><asp:Label ID="lblExamTitle" runat="server" /><br></strong></h5>
                                    <h5><strong><u>SECOND DUMMY ADMIT CARD</strong></u><br />
                                    </h5>
                                    <h5><strong><u>द्वितीय डमी एडमिट कार्ड</u></strong></h5>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <asp:PlaceHolder ID="phFaculty" runat="server">
                                    <asp:Label runat="server" ID="lblFacultyHindi" />
                                    <br />
                                </asp:PlaceHolder>
                                <%--<label style="margin-left: 37px;" id="lblFacultyName"><strong>FACULTY:</strong> <%# Eval("FacultyName") %></label>--%>
                               <asp:Label  ID="lblFacultyName"  runat="server" Text='<%# "FACULTY: " + Eval("FacultyName") %>'  Font-Bold="true"  Style="margin-left:37px;" />

                                 <asp:HiddenField ID="hfFacultyName" runat="server" Value='<%# Eval("FacultyName") %>' />
                                 
                            </div>
                        </div>
                    </div>
                    <div class="borderline">
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr>
                                <asp:HiddenField ID="hfFacultyId" runat="server" Value='<%# Eval("FacultyId") %>' />
                                  <asp:HiddenField ID="hfHasVocationalSubjects" runat="server" Value='<%# Eval("HasVocationalSubjects") %>' />
                                <td style="width: 85%; vertical-align: top; padding-right: 10px;">

                                    <table style="width: 100%; font-size: 17px; border-collapse: collapse;">
                                        <tr>
                                            <td>BSEB UNIQUE Id</td>
                                            <td><%# Eval("UniqueNo") %></td>
                                        </tr>
                                        <tr>
                                            <td>कॉलेज/+2 स्कूल का नाम</td>
                                            <td><%# Eval("CollegeName") %></td>
                                        </tr>
                                        <tr>
                                            <td>परीक्षार्थी का नाम</td>
                                            <td><%# Eval("StudentName") %></td>
                                        </tr>
                                        <tr>
                                            <td>माता का नाम</td>
                                            <td><%# Eval("MotherName") %></td>
                                        </tr>
                                        <tr>
                                            <td>पिता का नाम</td>
                                            <td><%# Eval("FatherName") %></td>
                                        </tr>
                                        <tr>
                                            <td>वैवाहिक स्थिति </td>
                                            <td><%# Eval("MaritalStatus") %></td>
                                        </tr>
                                        <tr>
                                            <td>परीक्षार्थी का आधार नं०</td>
                                            <td><%# Eval("AadharNo") %></td>
                                            <td>दिव्यांग कोटि:</td>
                                            <td><%# Eval("Disability") != DBNull.Value && Convert.ToBoolean(Eval("Disability")) ? "YES" : "NO" %></td>
                                        </tr>
                                        <tr>
                                            <td>सूचीकरण संख्या/वर्ष</td>
                                            <td><%# Eval("RegistrationNo") %></td>
                                            <td>परीक्षार्थी की कोटि</td>
                                            <td><%# Eval("ExamTypeName") %></td>
                                        </tr>
                                        <tr>
                                            <td>रौल कोड</td>
                                            <td><%# Eval("RollCode") %></td>
                                            <td>रौल क्रमांक</td>
                                            <td><%# Eval("RollNumber") %></td>
                                            <td>लिंग</td>
                                            <td><%# Eval("Gender") %></td>
                                        </tr>
                                        <tr>
                                            <td>परीक्षा केंद्र का नाम</td>
                                            <td colspan="5"><%# Eval("TheoryExamCenterName") %></td>
                                        </tr>
                                        <tr>
                                            <td>सैद्धान्तिक वार्षिक परीक्षा के विषय</td>
                                            <td colspan="5"></td>
                                        </tr>
                                    </table>

                                </td>

                                <td style="width: 15%; text-align: center; vertical-align: top;">
                                    <div style="border: 1px solid black; padding: 5px; display: inline-block;">
                                        <img src='<%# Page.ResolveUrl(Eval("StudentPhotoPath").ToString()) %>' alt="Student Photo" style="width: 100%; max-width: 130px; height: auto;">
                                    </div>
                                    <div style="margin-top: 10px;">
                                        <img src='<%# Page.ResolveUrl(Eval("StudentSignaturePath").ToString()) %>' alt="Signature" style="width: 100%; max-width: 130px; height: auto;">
                                    </div>
                                </td>
                            </tr>
                        </table>

                        <table class="subjects-table">
                            <thead>
                                <tr>
                                    <th colspan="3">अनिवार्य विषय<br>
                                        (Compulsory Subjects)</th>
                                    <th colspan="3">ऐच्छिक विषय<br>
                                        (Elective Subjects)</th>
                                    <th colspan="2">अतिरिक्त विषय<br>
                                        (Additional Subject)</th>
                                    <%--<th colspan="2">व्यावसायिक ट्रेड<br>
                                    (Vocational Trade)</th>--%>
                                    <%--<asp:PlaceHolder ID="phVocationalHeader" runat="server" Visible='<%# Eval("HasVocationalSubjects") %>'>--%>
                                        <th colspan="2" runat="server" id="trVocational">व्यावसायिक ट्रेड<br> (Vocational Trade)</th>
                                    <%--</asp:PlaceHolder>--%>

                                </tr>
                                <tr>
                                    <th>भाषा विषय</th>
                                    <th>विषय कोड</th>
                                    <th>विषय का नाम</th>
                                    <th>ऐच्छिक विषय</th>
                                    <th>विषय कोड</th>
                                    <th>विषय का नाम</th>
                                    <th>विषय कोड</th>
                                    <th>विषय का नाम</th>
                                    <%--<asp:PlaceHolder ID="PlaceHolder1" runat="server" Visible='<%# Eval("HasVocationalSubjects") %>'>--%>
                                        <th  runat="server" id="trVocationalVishay1">विषय कोड</th>
                                        <th runat="server" id="trVocationalVishay2">विषय का नाम</th>
                                    <%--</asp:PlaceHolder>--%>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><b>भाषा विषय-1</b></td>
                                    <td><%# Eval("CompulsorySubject1Code") %></td>
                                    <td><%# Eval("CompulsorySubject1Name") %></td>
                                    <td><b>ऐच्छिक विषय-1</b></td>
                                    <td><%# Eval("ElectiveSubject1Code") %></td>
                                    <td><%# Eval("ElectiveSubject1Name") %></td>
                                    <td rowspan="3"><%# Eval("AdditionalSubjectCode") %></td>
                                    <td rowspan="3"><%# Eval("AdditionalSubjectName") %></td>
                                    <%--    <td rowspan="3"><%# Eval("VocationalSubjectCode1Code") %></td>
                                <td rowspan="3"><%# Eval("VocationalSubjectName1Name") %></td>--%>
                                    <%--<asp:PlaceHolder ID="phVocational" runat="server" Visible='<%# Convert.ToBoolean(Eval("HasVocationalSubjects")) %>'>--%>
                                        <td rowspan="3"  runat="server" id="trVocationalCode"><%# Eval("VocationalSubjectCode1Code") %></td>
                                        <td rowspan="3"  runat="server" id="trVocationalCode1"><%# Eval("VocationalSubjectName1Name") %></td>

                                    <%--</asp:PlaceHolder>--%>


                                </tr>
                                <tr>
                                    <td><b>भाषा विषय-2</b></td>
                                    <td><%# Eval("CompulsorySubject2Code") %></td>
                                    <td><%# Eval("CompulsorySubject2Name") %></td>
                                    <td><b>ऐच्छिक विषय-2</b></td>
                                    <td><%# Eval("ElectiveSubject2Code") %></td>
                                    <td><%# Eval("ElectiveSubject2Name") %></td>
                                </tr>

                                <tr>
                                    <td colspan="3"></td>
                                    <%-- <td><%# Eval("CompulsorySubject3Code") %></td>
                                <td><%# Eval("CompulsorySubject3Name") %></td>--%>
                                    <td><b>ऐच्छिक विषय-3</b></td>
                                    <td><%# Eval("ElectiveSubject3Code") %></td>
                                    <td><%# Eval("ElectiveSubject3Name") %></td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="" style="font-family: 'Noto Sans Devanagari', 'Mangal', 'Arial', sans-serif; font-size: 17px; margin-top: 65px;">

                            <!-- Signature block -->
                            <div class="mb-3 row" style="margin-top: 80px;">
                                     <div class="col-md-6">

                                          <strong><asp:Label ID="lblExamSchoolHindi" runat="server" /><br>
                                             </strong>
                                     </div>
                                     <div class="col-md-6 text-end">

                                         <strong>परीक्षा नियंत्रक (उ0मा0)</strong>
                                     </div>
                                 </div>
                            <%--<hr style="border-top:var(--bs-border-width) solid black;opacity: 1;border: 2px;" />--%>
                            <hr style="font-size: 16px; border: 2px solid black !important; opacity: 1.25 !important;" />
                            <!-- Heading -->
                            <h6 class="text-center mb-3"><u>परीक्षार्थी के लिए आवश्यक निर्देश</u></h6>
                            <ol>
                                <li class="list-item">डमी प्रवेश-पत्र में यदि किसी विद्यार्थी के नाम, माता/पिता के नाम के स्पेलिंग में त्रुटि हो, वैवाहिक स्थिति, कोटि, लिंग, विषय, फोटो या हस्ताक्षर आदि में किसी प्रकार की त्रुटि परिलक्षित होती है, तो उससे संबंधित साक्ष्य एवं अपने हस्ताक्षर के साथ डमी प्रवेश-पत्र में संशोधन कर ऑनलाइन सुधार हेतु दिनांक xx-xx-xxxx तक अपने +2 विद्यालय/महाविद्यालय प्रधान को हस्तगत कराना सुनिश्चित करेंगे तथा डमी प्रवेश-पत्र की दूसरी प्रति शिक्षण संस्थान के प्रधान का हस्ताक्षर एवं मुहर प्राप्त कर अपने पास सुरक्षित रख लेंगे।
                                </li>
                                <li class="list-item">संबंधित +2 विद्यालय/महाविद्यालय प्रधान दिनांक xx-xx-xxxx तक की अवधि में विद्यार्थी के द्वारा डमी प्रवेश-पत्र में प्रतिवेदित त्रुटि का ऑनलाइन सुधार अनिवार्य रूप से करना सुनिश्चित करेंगे।
                                </li>
                                <li class="list-item">डमी प्रवेश-पत्र में विद्यार्थी का रौल नम्बर, परीक्षा केन्द्र का नाम तथा परीक्षा की तिथि अंकित नहीं किया गया है। मूल प्रवेश-पत्र में इसे जारी किया जाएगा।
                                </li>
                                <li class="list-item">इन्टरमीडिएट परीक्षा सत्र 2024-26 के नियमित कोटि के विद्यार्थियों के परीक्षा का विषय उनके सूचीकरण प्रमाण-पत्र के आधार पर अंकित किया गया है।
                                </li>
                                <li class="list-item">इसी प्रकार पूर्व के सत्रों में सूचीकृत वैसे पूर्ववर्ती विद्यार्थी, जो अभी तक इन्टरमीडिएट परीक्षा में अनुत्तीर्ण हैं अथवा सूचीकृत होने के उपरांत किसी कारणवश परीक्षा आवेदन नहीं भर पाये या परीक्षा में सम्मिलित नहीं हो पाये, उनके परीक्षा का विषय सूचीकरण प्रमाण-पत्र के आधार पर ही अंकित किया गया है।
                                </li>
                                <li class="list-item">समुन्नत कोटि के विद्यार्थियों के परीक्षा का विषय वही अंकित किया गया है, जिस उत्तीर्ण विषय/विषयों के परीक्षाफल को बेहतर किये जाने हेतु (For Improvement) उनके द्वारा आवेदन किया गया है।
                                </li>
                                <li class="list-item">कम्पार्टमेन्टल कोटि के पात्र परीक्षार्थियों का इंटरमीडिएट वार्षिक परीक्षा, 2026 के लिए उन्हीं विषय/विषयों (अधिकतम 02) को अंकित किया गया है, जिसमें वे अभी तक अनुत्तीर्ण हैं।
                                </li>
                                <li class="list-item">यह डमी प्रवेश-पत्र है, जिसके आधार पर परीक्षार्थी का परीक्षा केन्द्र में प्रवेश मान्य नहीं है।

                                </li>
                            </ol>
                            <!-- Instructions -->

                        </div>
                        <hr style="font-size: 16px; border: 2px solid black !important; opacity: 1.25 !important;" />
                        


                    </div>

                    <b>
                        <div id="infoDiv"></div>
                    </b>
                </div>


                <div style="page-break-after: always;" class="no-print"></div>
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

               // Format current date/time
               const now = new Date();
               const options = {
                   weekday: 'long',
                   year: 'numeric',
                   month: 'long',
                   day: 'numeric',
                   hour: 'numeric',
                   minute: '2-digit',
                   second: '2-digit',
                   hour12: true
               };
               const formattedDate = now.toLocaleString('en-US', options);

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

                   // Add the image content
                   pdf.addImage(imgData, 'JPEG', 0, 0, pdfWidth, pdfHeight);

                   // Add footer (date-time and page number)
                   pdf.setFontSize(10);
                   pdf.setTextColor(0, 0, 0);
                   pdf.text(`${formattedDate}    Page ${i + 1} of ${elements.length}`, 10, 290); // 10 = x, 290 = y (bottom)
               }

               pdf.save('AdmitCards.pdf');
           }
       </script>

    </form>

</body>
</html>
