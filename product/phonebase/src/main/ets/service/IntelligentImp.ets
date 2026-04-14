/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EventType, scbEventExclusiveManager } from '@ohos/windowscene';

import { IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { NegativeScreenConstants, sOutSideWindowMgr } from '@ohos/frameworkwrapper';

const TAG = 'IntelligentImp';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AA, TAG);

/**
 * 负一屏接口
 */
export class IntelligentImp implements IExecutor {
  async execute(extra: object): Promise<string> {
    log.showInfo('%{public}s execute', TAG);
    sOutSideWindowMgr.hideIntelligent();
    setTimeout(() => {
      const searchParms: SearchParam = extra as SearchParam;
    }, NegativeScreenConstants.DURATION_AUTO_DISAPPEAR);
    return DataShareResultCode.HANDLE_SUCCESS;
  }
}

interface SearchParam {
  bundleName: string;
  abilityName: string;
  moduleName: string;
  typeId: number;
  entityId: string;
}

/**
 * 负一屏Datashare接口调用返回码
 */
export const enum DataShareResultCode {
  // 处理成功
  HANDLE_SUCCESS = '1',
  // 处理过程有错误
  HANDLE_FAIL = '-1',
  // 调用方不在可访问白名单中
  VERIFY_IDENTITY_FAIL = '0',
  // 隐私未同意
  PRIVACY_NOT_AGREED = '2',
  // 服务卡片模块关闭
  SERVICE_CARD_CLOSE = '3',
  // 数据未校验通过
  VERIFY_DATA_FAIL = '4'
}