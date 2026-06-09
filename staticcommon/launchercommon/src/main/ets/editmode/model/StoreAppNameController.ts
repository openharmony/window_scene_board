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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { Response } from '../../constants/Response';
import { RpcConstants } from '../../constants/RpcConstants';
import { editModeManager, IExecutor } from '../../TsIndex';

const TAG = 'StoreAppNameController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 店铺名称控制类
 */
export class StoreAppNameController implements IExecutor {

  async execute(extra?: object): Promise<string> {
    if (CheckEmptyUtils.isEmpty(extra)) {
      log.showWarn('extra is null');
      return Response.FAIL;
    }
    try {
      let state: boolean = extra?.[RpcConstants.STORE_NAME_STATE];
      log.showInfo('state: %{public}s', state);
      // 根据入参控制名称显隐
      if (!CheckEmptyUtils.isEmpty(state)) {
        editModeManager.updateShowAppName(state);
        return Response.SUCCESS;
      }
    } catch (error) {
      log.showError(`StoreAppNameController error: ${error?.message}`);
    }
    return Response.FAIL;
  }

}

