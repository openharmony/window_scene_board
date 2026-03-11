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

import { BusinessError } from '@kit.BasicServicesKit';
import dataPreferences from '@ohos.data.preferences';
import { contextConstant } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SingletonHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';


const TAG = 'OobePreferences_OobeManager';
const NAME = 'OobePreferences_OobeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * OOBE的Preferences类
 */
export class OobePreferences {
  mPreferences?: dataPreferences.Preferences;


  /**
   * 获取单例对象
   */
  public static getInstance(): OobePreferences {
    return SingletonHelper.getInstance(OobePreferences, TAG);
  }

  /**
   * 判断preferences中是否存在指定key的值
   * @param context context
   * @param key key
   */
  public async hasValue(key: string): Promise<boolean> {
    await this.initPreferences();
    if (!this.mPreferences) {
      return false;
    }
    return this.mPreferences.has(key);
  }

  /**
   * 获取preferences中指定key值
   * @param key key
   * @param defValue 默认值
   */
  public async getValue(key: string, defValue: dataPreferences.ValueType): Promise<dataPreferences.ValueType> {
    await this.initPreferences();
    if (!this.mPreferences) {
      return defValue;
    }
    return this.mPreferences.getSync(key, defValue);
  }

  /**
   * 设置preferences中指定key值
   * @param key key
   * @param defValue 默认值
   */
  public async setValue(key: string, value: dataPreferences.ValueType): Promise<void> {
    await this.initPreferences();
    log.showInfo(`setValue key:${key} value:${value}`);
    if (!this.mPreferences) {
      return;
    }
    this.mPreferences.putSync(key, value);
    await this.mPreferences.flush().then(() => {
      log.showInfo(`setValue ${key} to sp successs`);
    }).catch((error: BusinessError) => {
      log.error(`setValue ${key} to sp error`, error);
    });
  }

  /**
   * 获取Preferences对象
   */
  private async initPreferences(): Promise<void> {
    if (!this.mPreferences) {
      try {
        let context = GlobalContext.getContext();
        context.area = contextConstant.AreaMode.EL1;
        this.mPreferences = await dataPreferences.getPreferences(context, NAME);
      } catch (error) {
        log.error('initPreferences error', error);
      }
    }
  }
}
