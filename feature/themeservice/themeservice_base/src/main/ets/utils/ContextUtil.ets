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

import type common from '@ohos.app.ability.common';
import contextConstant from '@ohos.app.ability.contextConstant';
import { Singleton } from '../service/Singleton';

const TS_SERVICE_CONTEXT: string = 'TS_AbilityStageContext';

const TS_APPLICATION_CONTEXT: string = 'TS_ApplicationContext';

export class ContextUtil {
  private static sInstance: Singleton<ContextUtil> = new Singleton<ContextUtil>(() => new ContextUtil());

  private readonly objects = new Map<string, object>();

  private constructor() {
  }

  public static subscribeTsApplication(context: common.ServiceExtensionContext | common.AbilityStageContext): void {
    ContextUtil.getInstance().set(TS_SERVICE_CONTEXT, context);
    ContextUtil.getInstance().set(TS_APPLICATION_CONTEXT, context.createModuleContext(`themeservice_core`));
  }

  public static getTsApplicationContext(): common.ApplicationContext {
    let context: common.ApplicationContext =
      ContextUtil.getInstance().get(TS_APPLICATION_CONTEXT) as common.ApplicationContext;
    if (context) {
      context.area = contextConstant.AreaMode.EL1;
    }
    return context;
  }

  public static getTsServiceContext(): common.ServiceExtensionContext {
    return ContextUtil.getInstance().get(TS_SERVICE_CONTEXT) as common.ServiceExtensionContext;
  }

  public static getHostContext(): common.ServiceExtensionContext {
    return globalThis.desktopContext;
  }

  private static getInstance(): ContextUtil {
    return ContextUtil.sInstance.get();
  }

  private get(value: string): object | undefined {
    return this.objects.get(value);
  }

  private set(key: string, obj: object): void {
    this.objects.set(key, obj);
  }
}