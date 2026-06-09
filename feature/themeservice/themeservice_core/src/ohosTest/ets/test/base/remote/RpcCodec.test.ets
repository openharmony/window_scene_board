/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { describe, expect, it } from '@ohos/hypium';
import { RpcCodec } from '@ohos/themeservicebase/src/main/ets/remote/RpcCodec';

export default function RpcCodecTest() {
  describe('RpcCodecTest', () => {
    it('RpcCodecTest01_result_false', 0, async () => {
      let bRet: boolean = false;
      let rsp: string | undefined = RpcCodec.encodeRsp(bRet);
      console.log(`RspCodec_boolean: ${rsp}`)
      expect(RpcCodec.decodeRsp(rsp)).assertFalse();
    })

    it('RpcCodecTest02_result_true', 0, async () => {
      let bRet: boolean = true;
      let rsp: string | undefined = RpcCodec.encodeRsp(bRet);
      console.log(`RspCodec_boolean: ${rsp}`)
      expect(RpcCodec.decodeRsp(rsp)).assertTrue();
    })

    it('RpcCodecTest03_result_number', 0, async () => {
      let bRet: number = 1000;
      let rsp: string | undefined = RpcCodec.encodeRsp(bRet);
      console.log(`RspCodec_number: ${rsp}`)
      expect(RpcCodec.decodeRsp(rsp)).assertEqual(bRet);
    })

    it('RpcCodecTest03_result_string', 0, async () => {
      let bRet: string = `1000`;
      let rsp: string | undefined = RpcCodec.encodeRsp(bRet);
      console.log(`RspCodec_string: ${rsp}`)
      expect(RpcCodec.decodeRsp(rsp)).assertEqual(bRet);
    })
  })
}