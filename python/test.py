# import jwt
# encodes = jwt.encode({'username':"test",'exp':"555"},key="",algorithm='HS256')
# print(encodes)

# import bcrypt
# ttt = b'$2b$12$6yEn.vQ189l0iZIUUl9MO.U1guxNzSOTpF3dbpdRTTeaq2rbR/.bO'

# t = "sdfskdfs"
# print(t.encode("utf-8"))
# ###gen
# passwd = '123456789'.encode('utf-8')
# salt = bcrypt.gensalt()
# hashed = bcrypt.hashpw(passwd, salt)
# print(hashed.decode())
# ##check
# print(bcrypt.checkpw(passwd,ttt))
# if bcrypt.checkpw(passwd, ttt):
#     print("match")
# else:
#     print("does not match")