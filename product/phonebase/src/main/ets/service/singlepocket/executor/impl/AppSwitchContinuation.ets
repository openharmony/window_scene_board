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
import { IExecutor } from '../IExecutor';
import lazy { OuterHomeManagerUtil } from '../../../../SceneBoard/screenlock/utils/OuterHomeManagerUtil';


const TAG = 'appSwitchContinuation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 调用应用接续接口
 *
 * @since 2024-12-02
 */
export class AppSwitchContinuation implements IExecutor {
  /**
   * 折叠到外屏时，启动或关闭应用接续
   * @param extra
   */
  async execute(extra?: boolean): Promise<void> {
    let enable: boolean = extra ?? false;
    log.info(`AppSwitchContinuation execute enable: ${enable}`);
    OuterHomeManagerUtil.getInstance().setAppSwitchContinuation(enable);
  }
}