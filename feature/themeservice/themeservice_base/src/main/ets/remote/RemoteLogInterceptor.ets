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

import { TsLog } from '../log/TsLog';
import { JsonUtils } from '../utils/JsonUtils';
import { RemoteInterceptor } from './RemoteInterceptor';
import { RemoteReq } from './RemoteReq';
import { RemoteRsp } from './RemoteRsp';

const TAG: string = 'TSRemoteLogInterceptor';

class PreRemoteInterceptor implements RemoteInterceptor {
  intercept(timestamp: number, req: RemoteReq, _rsp: RemoteRsp): Promise<boolean> | boolean {
    if (TsLog.isDebug(TAG)) {
      printLongLog(
        `Remote req(${timestamp}) [${req?.method}] start, req: ${JsonUtils.stringify(req?.args)}`);
    } else {
      printLongLog(`Remote req(${timestamp}) [${req?.method}] start`);
    }
    return false;
  }
}

class PostRemoteInterceptor implements RemoteInterceptor {
  intercept(timestamp: number, req: RemoteReq, rsp: RemoteRsp): Promise<boolean> | boolean {
    const elapsedTime: number = new Date().getTime() - timestamp;
    if (TsLog.isDebug(TAG) && rsp.value) {
      const rspLog: string | number | undefined =
        JsonUtils.stringify(new RemoteRsp(rsp.code, rsp.desc, JsonUtils.parse(rsp.value)));
      printLongLog(`Remote req(${timestamp}) [${req?.method}] end, consumeTime:${elapsedTime}, rsp: ${rspLog}`);
    } else {
      printLongLog(`Remote req(${timestamp}) [${req?.method}] end, consumeTime:${elapsedTime}, rsp: ${rsp.code}`);
    }
    return false;
  }
}

function printLongLog(logContent: string, maxSize: number = 2000): void {
  if (logContent.length <= maxSize) {
    printLog(logContent);
  } else {
    let remainingContent: string = logContent;
    while (remainingContent.length > maxSize) {
      const logPart = remainingContent.substring(0, maxSize);
      printLog(logPart);
      remainingContent = remainingContent.substring(maxSize);
    }
    printLog(remainingContent);
  }
}

function printLog(logContent: string) {
  TsLog.info(TAG, `${TAG} -> ${logContent}`);
}

export const logPreInterceptor: RemoteInterceptor = new PreRemoteInterceptor;

export const logPostInterceptor: RemoteInterceptor = new PostRemoteInterceptor;