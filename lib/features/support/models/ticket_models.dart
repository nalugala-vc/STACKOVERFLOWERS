class Ticket {
  final int id;
  final int ticketid;
  final String tid;
  final String c;
  final int deptid;
  final String deptname;
  final int userid;
  final int contactid;
  final String name;
  final String ownerName;
  final String email;
  final String requestorName;
  final String requestorEmail;
  final String requestorType;
  final String cc;
  final String date;
  final String subject;
  final String status;
  final String priority;
  final String admin;
  final String attachment;
  final List<dynamic> attachments;
  final bool attachmentsRemoved;
  final String lastreply;
  final int flag;
  final String service;
  final List<TicketReply>? replies;
  final List<dynamic>? notes;

  Ticket({
    required this.id,
    required this.ticketid,
    required this.tid,
    required this.c,
    required this.deptid,
    required this.deptname,
    required this.userid,
    required this.contactid,
    required this.name,
    required this.ownerName,
    required this.email,
    required this.requestorName,
    required this.requestorEmail,
    required this.requestorType,
    required this.cc,
    required this.date,
    required this.subject,
    required this.status,
    required this.priority,
    required this.admin,
    required this.attachment,
    required this.attachments,
    required this.attachmentsRemoved,
    required this.lastreply,
    required this.flag,
    required this.service,
    this.replies,
    this.notes,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as int,
      ticketid: json['ticketid'] as int,
      tid: json['tid'] as String,
      c: json['c'] as String,
      deptid: json['deptid'] as int,
      deptname: json['deptname'] as String,
      userid: json['userid'] as int,
      contactid: json['contactid'] as int,
      name: json['name'] as String,
      ownerName: json['owner_name'] as String,
      email: json['email'] as String,
      requestorName: json['requestor_name'] as String,
      requestorEmail: json['requestor_email'] as String,
      requestorType: json['requestor_type'] as String,
      cc: json['cc'] as String,
      date: json['date'] as String,
      subject: json['subject'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      admin: json['admin'] as String,
      attachment: json['attachment'] as String,
      attachments: json['attachments'] as List<dynamic>,
      attachmentsRemoved: json['attachments_removed'] as bool,
      lastreply: json['lastreply'] as String,
      flag: json['flag'] as int,
      service: json['service'] as String,
      replies:
          json['replies'] != null
              ? (json['replies']['reply'] as List<dynamic>)
                  .map((reply) => TicketReply.fromJson(reply))
                  .toList()
              : null,
      notes: json['notes'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketid': ticketid,
      'tid': tid,
      'c': c,
      'deptid': deptid,
      'deptname': deptname,
      'userid': userid,
      'contactid': contactid,
      'name': name,
      'owner_name': ownerName,
      'email': email,
      'requestor_name': requestorName,
      'requestor_email': requestorEmail,
      'requestor_type': requestorType,
      'cc': cc,
      'date': date,
      'subject': subject,
      'status': status,
      'priority': priority,
      'admin': admin,
      'attachment': attachment,
      'attachments': attachments,
      'attachments_removed': attachmentsRemoved,
      'lastreply': lastreply,
      'flag': flag,
      'service': service,
      'replies': replies?.map((reply) => reply.toJson()).toList(),
      'notes': notes,
    };
  }
}

class TicketReply {
  final String replyid;
  final int userid;
  final int contactid;
  final String name;
  final String email;
  final String requestorName;
  final String requestorEmail;
  final String requestorType;
  final String date;
  final String message;
  final String attachment;
  final List<dynamic> attachments;
  final bool attachmentsRemoved;
  final String admin;
  final int? rating;

  TicketReply({
    required this.replyid,
    required this.userid,
    required this.contactid,
    required this.name,
    required this.email,
    required this.requestorName,
    required this.requestorEmail,
    required this.requestorType,
    required this.date,
    required this.message,
    required this.attachment,
    required this.attachments,
    required this.attachmentsRemoved,
    required this.admin,
    this.rating,
  });

  factory TicketReply.fromJson(Map<String, dynamic> json) {
    return TicketReply(
      replyid: json['replyid'].toString(),
      userid: json['userid'] as int,
      contactid: json['contactid'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      requestorName: json['requestor_name'] as String,
      requestorEmail: json['requestor_email'] as String,
      requestorType: json['requestor_type'] as String,
      date: json['date'] as String,
      message: json['message'] as String,
      attachment: json['attachment'] as String,
      attachments: json['attachments'] as List<dynamic>,
      attachmentsRemoved:
          json['attachments_removed'] == 1 ||
          json['attachments_removed'] == true,
      admin: json['admin'] as String,
      rating: json['rating'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'replyid': replyid,
      'userid': userid,
      'contactid': contactid,
      'name': name,
      'email': email,
      'requestor_name': requestorName,
      'requestor_email': requestorEmail,
      'requestor_type': requestorType,
      'date': date,
      'message': message,
      'attachment': attachment,
      'attachments': attachments,
      'attachments_removed': attachmentsRemoved,
      'admin': admin,
      'rating': rating,
    };
  }
}

class TicketListResponse {
  final String result;
  final int totalResults;
  final int startNumber;
  final int numReturned;
  final List<Ticket> tickets;

  TicketListResponse({
    required this.result,
    required this.totalResults,
    required this.startNumber,
    required this.numReturned,
    required this.tickets,
  });

  factory TicketListResponse.fromJson(Map<String, dynamic> json) {
    final ticketsData = json['tickets'] as Map<String, dynamic>;
    final ticketList = ticketsData['ticket'] as List<dynamic>;

    return TicketListResponse(
      result: json['result'] as String,
      totalResults: json['totalresults'] as int,
      startNumber: json['startnumber'] as int,
      numReturned: json['numreturned'] as int,
      tickets: ticketList.map((ticket) => Ticket.fromJson(ticket)).toList(),
    );
  }
}

class CreateTicketRequest {
  final String subject;
  final String message;

  CreateTicketRequest({required this.subject, required this.message});

  Map<String, dynamic> toJson() {
    return {'subject': subject, 'message': message};
  }
}

class CreateTicketResponse {
  final bool success;
  final String message;
  final CreateTicketData data;

  CreateTicketResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateTicketResponse.fromJson(Map<String, dynamic> json) {
    return CreateTicketResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: CreateTicketData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class CreateTicketData {
  final String result;
  final int id;
  final String tid;
  final String c;

  CreateTicketData({
    required this.result,
    required this.id,
    required this.tid,
    required this.c,
  });

  factory CreateTicketData.fromJson(Map<String, dynamic> json) {
    return CreateTicketData(
      result: json['result'] as String,
      id: json['id'] as int,
      tid: json['tid'] as String,
      c: json['c'] as String,
    );
  }
}

class ReplyTicketRequest {
  final String message;

  ReplyTicketRequest({required this.message});

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

class ReplyTicketResponse {
  final String result;

  ReplyTicketResponse({required this.result});

  factory ReplyTicketResponse.fromJson(Map<String, dynamic> json) {
    return ReplyTicketResponse(result: json['result'] as String);
  }
}
