module Nwsdk
  module Constants
    NW_TIME_FORMAT = '%Y-%b-%d %H:%M:%S'
    NW_VARIANT_DAYS = %w{
      Sunday
      Monday
      Tuesday
      Wednesday
      Thursday
      Friday
      Saturday
    }
    #######
    #
    # Nwsdk Content Render Types
    #
    #######

    NW_CONTENT_TYPE_AUTO           = 0,   # Auto Select HTML Content View
    NW_CONTENT_TYPE_DETAILS        = 1,   # HTML Meta Details View
    NW_CONTENT_TYPE_TEXT           = 2,   # HTML Text View
    NW_CONTENT_TYPE_HEX            = 3,   # HTML Hex View
    NW_CONTENT_TYPE_PACKETS        = 4,   # HTML Packet View
    NW_CONTENT_TYPE_MAIL           = 5,   # HTML Mail View
    NW_CONTENT_TYPE_WEB            = 6,   # HTML Web Page View
    NW_CONTENT_TYPE_VOIP           = 7,   # HTML VOIP View
    NW_CONTENT_TYPE_IM             = 8,   # HTML IM View
    NW_CONTENT_TYPE_FILES          = 9,   # HTML Listing of all files found in session
    NW_CONTENT_TYPE_PCAP           = 100, # Pcap Packet File
    NW_CONTENT_TYPE_RAW            = 102, # Raw Content
    NW_CONTENT_TYPE_XML            = 103, # Meta XML File
    NW_CONTENT_TYPE_CSV            = 104, # Meta Comma Separated File
    NW_CONTENT_TYPE_TXT            = 105, # Meta Tab Separated File
    NW_CONTENT_TYPE_NWD            = 106, # Netwitness Data File
    NW_CONTENT_TYPE_FILE_EXTRACTOR = 107, # Extract files from common protocols
    NW_CONTENT_TYPE_LOGS           = 108, # Log extract (captured logs, LF delimited)
    NW_CONTENT_TYPE_PROTOBUF       = 109  # Content of the NWD as a Google Protocol Buffer object

    ######
    #
    #  Nwsdk Content Render Flags
    #
    ######

    NW_CONTENT_FLAG_STREAM1          = 0x00001, # Return only request stream
                                                #   content.
    NW_CONTENT_FLAG_STREAM2          = 0x00002, # Return only response stream
                                                #   content.
    NW_CONTENT_FLAG_SINGLE_COLUMN    = 0x00004, # Format generated web page as
                                                #   a single column with requests
                                                #   and responses interleaved.
    NW_CONTENT_FLAG_PACKET_PAYLOAD   = 0x00008, # Include only session payload.
    NW_CONTENT_FLAG_DECODEAS_EBCDIC  = 0x00010, # Convert session payload from EBCDIC to ASCII.
    NW_CONTENT_FLAG_DO_NOT_EMBED     = 0x00020, # Do not embed application/
                                                #   audio/video traffic into the
                                                #   generated web page.
    NW_CONTENT_FLAG_UNCOMPRESS_TEXT  = 0x00040, # Unzip web content in text view.
    NW_CONTENT_FLAG_DECODE_SSL       = 0x00080, # Attempt to decrypt SSL
                                                #   sessions if the encryption
                                                #   key is provided.
    NW_CONTENT_FLAG_STRIP_STYLE_TAGS = 0x00100, # Removes all &lt;style&gt; tags from the original
                                                #   html document.
    NW_CONTENT_FLAG_IGNORE_CACHE     = 0x01000, # Ignore any content in cache
                                                #   and requery, affects only
                                                #   current request.
    NW_CONTENT_FLAG_NO_EMBEDDED_EXE  = 0x02000, # Do not look for or extract
                                                #   hidden/embedded PE files
                                                #   when performing file
                                                #   extraction.
    NW_CONTENT_FLAG_INCLUDE_DUPS     = 0x04000, # Include packets otherwise removed by assembly
    NW_CONTENT_FLAG_INCLUDE_HEADERS  = 0x08000, # Include packet header meta information
    NW_CONTENT_FLAG_CAPTURE_ORDER    = 0x10000  # Do not assemble packets, return in capture order

    ######
    #
    # d.'e'fault config
    #
    #####
    DEFAULT_CONFIG = {
      "endpoint"=> {
        "user"=>"admin",
        "pass"=>"netwitness",
        "host"=>"broker.local",
        "port"=>"50103"
      },
      "syslog"=>{
        "loghost"=>"loghost.local",
        "logport"=>514
      },
      "cef_static_fields"=> {
        "deviceVendor"=>"ERCOT",
        "deviceProduct"=>"nwsdk",
        "deviceCustomString1Label"=>"threat.desc",
        "deviceCustomString2Label"=>"threat.source",
        "deviceCustomString3Label"=>"threat.category",
        "deviceCustomNumber1Label"=>"asn.src",
        "deviceCustomNumber2Label"=>"asn.dst"
      },
      "cef_mapping" => {
        "action"=>"deviceAction",
        "alias.host"=>"destinationProcessName",
        "asn.dst"=>"deviceCustomNumber2",
        "asn.src"=>"deviceCustomNumber1",
        "did"=>"deviceHostName",
        "directory"=>"filePath",
        "domain.dst"=>"destinationHostName",
        "eth.dst"=>"destinationMacAddress",
        "eth.src"=>"sourceMacAddress",
        "filename"=>"fileName",
        "ip.dst"=>"destinationAddress",
        "ip.proto"=>"transportProtocol",
        "ip.src"=>"sourceAddress",
        "risk.warning"=>"name",
        "risk.suspicious"=>"name",
        "service"=>"applicationProtocol",
        "sessionid"=>"externalId",
        "size"=>"bytesIn",
        "tcp.dstport"=>"destinationPort",
        "tcp.srcport"=>"sourcePort",
        "threat.desc"=>"deviceCustomString1",
        "threat.source"=>"deviceCustomString2",
        "threat.category"=>"deviceCustomString3",
        "udp.dstport"=>"destinationPort",
        "udp.srcport"=>"sourcePort",
        "username"=>"destinationUserName"
      }
    }
  end
end
