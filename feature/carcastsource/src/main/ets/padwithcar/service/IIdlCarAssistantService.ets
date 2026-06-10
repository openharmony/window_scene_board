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

/**
 * CarAssistant resource manager, starApp from CarAssistant through CarAssistantServiceExt
 */
export default interface CarAssistantService {

  /**
   * 传送消息到出行助手
   *
   * @param msg 消息
   */
  sendMsgToCarAssistant(msg: RpcMessage, callBack?: CommonCallBack): void;
}

export type CommonCallBack = (data?: string, errCode?: number) => void;

/**
 * 消息参数
 */
export interface RpcMessage {
  /**
   * 请求action
   */
  action: string;

  /**
   * 请求数据
   */
  extra?: Record<string, string>;
}
