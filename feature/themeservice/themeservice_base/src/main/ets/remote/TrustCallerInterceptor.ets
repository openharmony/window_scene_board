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
import { bundleManager } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { TsLog } from '../log/TsLog';
import { BundleUtils } from '../utils/BundleUtils';
import { Nullable } from '../utils/Types';
import { CalleeMethodSet, CallerInfo, MethodArgs } from './RemoteCallee';
import { RemoteCode } from './RemoteCode';
import { RemoteInterceptor } from './RemoteInterceptor';
import { RemoteReq } from './RemoteReq';
import { RemoteRsp } from './RemoteRsp';

const TAG: string = 'TrustCallersInterceptor';

/**
 * 可信调用者拦截器
 */
class TrustCallerInterceptor implements RemoteInterceptor {
  private readonly methodSet: CalleeMethodSet;

  constructor(methodSet: CalleeMethodSet) {
    this.methodSet = methodSet;
  }

  async intercept(_timestamp: number, req: RemoteReq, rsp: RemoteRsp): Promise<boolean> {
    let result: RemoteRsp = await this.checkCaller(req.method);
    rsp.code = result.code;
    rsp.desc = result.desc;
    return result.code !== RemoteCode.SUCCESS;
  }

  private async checkCaller(method: Nullable<string>): Promise<RemoteRsp> {
    if (!method) {
      return RemoteRsp.ERR_PARAM;
    }
    let methodArg: MethodArgs = this.methodSet.get(method);
    if (!methodArg) {
      return RemoteRsp.ERR_API_NOT_EXIST;
    }
    // 未配置安全策略，无需安全校验安全
    if (!methodArg.securityPolicy) {
      return RemoteRsp.SUCCESS;
    }
    const callerUid: number = rpc.IPCSkeleton.getCallingUid();
    let result: RemoteRsp = await this.checkRemoteCaller(methodArg.securityPolicy.trustCallers, callerUid, method);
    return result;
  }

  private async checkRemoteCaller(trustCallers: Nullable<CallerInfo[]>, callerUid: number,
    method: string): Promise<RemoteRsp> {
    if (!trustCallers) {
      return RemoteRsp.SUCCESS;
    }
    const callerBundleName: Nullable<string> = await BundleUtils.getBundleNameByUid(callerUid);
    TsLog.debug(TAG, `checkRemoteCaller:${callerBundleName}`);
    if (!callerBundleName) {
      // 系统取不到BundleName
      TsLog.error(TAG, `"${method}" Failed to obtain the BundleName based on the ID "${callerUid}".`);
      return RemoteRsp.ERR_OHOS_ERROR;
    }
    let trustCallInfo: Nullable<CallerInfo> =
      trustCallers.find((callerInfo) => callerInfo?.bundleName === callerBundleName);
    if (!trustCallInfo) {
      TsLog.warning(TAG, `"${method}"  does not have the permission to invoke the method`);
      return RemoteRsp.ERR_ILLEGAL_CALLER;
    }
    let signatureInfo: Nullable<bundleManager.SignatureInfo> = await BundleUtils.getBundleSignature(callerBundleName);
    if (!signatureInfo) {
      TsLog.error(TAG, `"${method}" Failed to obtain the signatureInfo by ${callerBundleName}".`);
      return RemoteRsp.ERR_OHOS_ERROR;
    }
    if (trustCallInfo.appId && trustCallInfo.appId !== signatureInfo.appId) {
      TsLog.error(TAG, `"${method}" does not have valid appid to invoke the method ${callerBundleName}".`);
      return RemoteRsp.ERR_ILLEGAL_CALLER;
    }
    if (trustCallInfo.fingerprint && trustCallInfo.fingerprint !== signatureInfo.fingerprint) {
      TsLog.error(TAG, `"${method}" does not have valid fingerprint to invoke the method ${callerBundleName}".`);
      return RemoteRsp.ERR_ILLEGAL_CALLER;
    }
    if (trustCallInfo.appIdentifier && trustCallInfo.appIdentifier !== signatureInfo.appIdentifier) {
      TsLog.error(TAG, `"${method}" does not have valid appIdentifier to invoke the method ${callerBundleName}".`);
      return RemoteRsp.ERR_ILLEGAL_CALLER;
    }
    return RemoteRsp.SUCCESS;
  }
}

export function trustCallerInterceptor(methodSet: CalleeMethodSet): RemoteInterceptor {
  return new TrustCallerInterceptor(methodSet);
}