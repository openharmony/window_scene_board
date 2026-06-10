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
import lazy common from '@ohos.app.ability.common';
import { Constants } from './Constants';
import { DeviceUtil } from './DeviceUtil';
import { Log } from './Log';
import { Singleton } from './Singleton';

const HOST_CONTEXT: string = 'host_context';

const MODULE_CONTEXT: string = 'module_context';

const TAG: string = 'SysContextUtil';

export class SysContextUtil {
  private static sInstance: Singleton<SysContextUtil> = new Singleton<SysContextUtil>(() => new SysContextUtil());
  private readonly objects = new Map<string, object>();
  private uiContext: UIContext | null = null;

  public static subscribe(hostContext: Context): void {
    SysContextUtil.getInstance().set(HOST_CONTEXT, hostContext);
    SysContextUtil.getInstance().set(MODULE_CONTEXT, SysContextUtil.createModuleContext(hostContext));
  }

  public static setUIContext(uiContext: UIContext): void {
    SysContextUtil.getInstance().uiContext = uiContext;
  }

  public static getUIContext(): UIContext | null {
    return SysContextUtil.getInstance().uiContext;
  }

  public static createModuleContext(hostContext: Context): Context {
    let moduleContext: Context;
    try {
      if (DeviceUtil.isTV()) {
        moduleContext = hostContext.createModuleContext('com.ohos.animatronix', 'animatronix_tv');
      } else {
        moduleContext = hostContext.createModuleContext('com.ohos.animatronix', 'animatronix');
      }
    } catch (err) {
      Log.warn(TAG, `createModuleContext catch exception, moduleContext usage hostContext`, err);
      moduleContext = hostContext;
    }
    return moduleContext;
  }

  public static getHostContext(): Context {
    return SysContextUtil.getInstance().get(HOST_CONTEXT);
  }

  public static getModuleContext(): Context {
    return SysContextUtil.getInstance().get(MODULE_CONTEXT);
  }

  public static getDarkMode(): number {
    const context: common.ExtensionContext = SysContextUtil.getInstance().get(HOST_CONTEXT) as common.ExtensionContext;
    let colorMode: number | undefined = context?.config?.colorMode;
    if (colorMode === undefined) {
      Log.error(TAG, 'get darkMode fail,the context does not contain config.');
      return Constants.SYSTEM_NOT_SUPPORT
    }
    return colorMode;
  }

  private static getInstance(): SysContextUtil {
    return SysContextUtil.sInstance.get();
  }

  private get(value: string): Context {
    return this.objects.get(value) as Context;
  }

  private set(key: string, context: Context): void {
    this.objects.set(key, context);
  }
}