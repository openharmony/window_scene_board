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

// import {
//   Content,
//   ContentData,
//   DispatchParams,
//   Header,
//   Session
// } from '@ohos-aidispatch/abilitybasesdkoh/src/main/ets/beans/DispatchParams';
import util from '@ohos.util';
import { DispatchParamsConstant } from '../constants/DispatchParamsConstant';
import type { OperateType } from '../constants/OperateType';

/**
 * 调用语音助手建议接口的参数构造器
 *
 * @since 2023-10-19
 */
export class DispatchParamsBuilder {
  // public dispatchParams: DispatchParams;

  static buildPayload(params: Record<string, Object>): object {
    const payload: Record<string, Object> = {};
    Object.keys(params).forEach((key, index) => {
      payload[key] = params[key];
    });
    return payload;
  }

  static buildDispatchParams(operateType: OperateType, payload?: object): ESObject {
    return new DispatchParamsBuilder(operateType, payload).build();
  }

  private constructor(operateType: OperateType, payload?: object) {
    // this.dispatchParams = new DispatchParams();
    // this.dispatchParams.session = this.buildSession();
    // this.dispatchParams.content = this.buildContent(operateType, payload);
  }

  private buildSession() {
    // const session = new Session();
    // session.messageName = DispatchParamsConstant.MESSAGE_NAME;
    // session.senderName = DispatchParamsConstant.SENDER_NAME;
    // session.serviceName = DispatchParamsConstant.SERVICE_NAME;
    // session.traceId = util.generateRandomUUID();
    // session.messageVersion = DispatchParamsConstant.MESSAGE_VERSION;
    // return session;
  }

  private buildContent(operateType: OperateType, payload?: object): ESObject {
    // const content = new Content();
    // content.contentData = this.buildContentData(operateType, payload);
    // return content;
  }

  private buildContentData(operateType: OperateType, payload?: object): ESObject {
    // const contentData = new ContentData();
    // contentData.header = this.buildHeader(operateType);
    // if (payload) {
    //   contentData.payload = payload;
    // }
    // return [contentData];
  }

  private buildHeader(operateType: OperateType): ESObject {
    // const header = new Header();
    // header.namespace = DispatchParamsConstant.NAME_SPACE;
    // header.name = operateType;
    // return header;
  }

  private build(): ESObject {
    // return this.dispatchParams;
  }
}