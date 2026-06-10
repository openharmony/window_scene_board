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

export default interface IIdlCarCastService {
  /**
   * recvMessage 接收到助手消息
   *
   * @param code 投屏业务码
   * @param bundleName 投屏参数
   * @param callback 结果返回
   */
  recvMessage(code: number, params: string, callback: resultStringCallback): void;
}

export type resultStringCallback = (errCode: number, returnValue: string) => void;
