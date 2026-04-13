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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { i18n } from '@kit.LocalizationKit';
import { BasicMediaController } from '../viewmodel/BasicMediaVM';
import { SysConfigData } from '../viewmodel/SysConfigData';
import { ConfigurationEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';

const TAG = 'SysConfigController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export class SysConfigController extends BasicMediaController {
  /*
    持续更新的基础播控数据集
   */
  private data: SysConfigData;

  constructor(data: SysConfigData) {
    super();
    this.data = data;
    this.init();
  }

  init() {
    this.getConfig();
    EvtBus.on(ConfigurationEvent, this.configurationChange);
  }

  private configurationChange = (event: ConfigurationEvent): void => {
    this.data.fontSizeScale = event?.config?.fontSizeScale || 1;
    this.getConfig();
  };

  getConfig() {
    try {
      let systemLanguage: string = i18n.System.getSystemLanguage();
      let isRTL: boolean = i18n.isRTL(systemLanguage);
      log.showInfo(`get systemLanguage: ${systemLanguage}， isRTL:${isRTL}`);
      this.data.language = systemLanguage;
      this.data.isRTL = isRTL;
    } catch (err) {
      log.showWarn('get i18n error')
    }
  }

  release() {
    EvtBus.off(ConfigurationEvent, this.configurationChange);
  }
}