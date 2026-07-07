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
import settings from '@ohos.settings';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { osAccount } from '@kit.BasicServicesKit';
import { process } from '@kit.ArkTS';
import { Context } from '@ohos.arkui.UIContext';

const ASSISTANT_SWITCH_KEY = 'fusion_assistant_privacy_on';
const ASSISTANT_SEARCH_KEY = 'fusion_assistant_privacy_search';
const FEATURE_MODE_KEY = 'fusion_basic_service_mode';

const SETTINGS_SWITCH_ON_PROP = '1';
const SETTINGS_SWITCH_OFF_PROP: string = '0';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'FusionSearchAdmissionController');

declare type PropListener<T> = (val: T) => void;

abstract class AbstractSettingsPropController<T> {
  protected val: T;
  protected listeners: Set<PropListener<T>> = new Set();

  constructor(defVal: T) {
    this.val = defVal;
  }

  public init = (): void => {
    const result = settings.registerKeyObserver(this.ctx, this.key, this.domain, (err, _data) => {
      log.showInfo('OnKeyChanged %{public}d', err?.code);
      this.refresh();
    });

    log.showInfo('Register result: %{public}s', result);
  }

  public destroy(): void {
    this.listeners.clear();
    const result = settings.unregisterKeyObserver(this.ctx, this.key, this.domain);
    log.showInfo('Destroy result: %{public}s', result);
  }

  public get value(): T {
    return this.val;
  }

  public get domain(): string {
    return settings.domainName.DEVICE_SHARED;
  }

  public registerListener(listener: PropListener<T>): void {
    this.listeners.add(listener);
  }

  public async refresh(): Promise<void> {
    try {
      this.val = await this.parseValue();
      this.notifyValueChanged(this.val);
    } catch (err) {
      log.error('Refresh error', err);
    }
  }

  abstract parseValue(): Promise<T>;

  get ctx(): Context {
    return ContextManager.getTopContext();
  }

  abstract get key(): string;

  protected async getValueCompletely(ctx: Context, key: string, optionDomain: string): Promise<string> {
    const domainProp = await settings.getValue(ctx, key, optionDomain);
    if (domainProp) {
      return domainProp;
    }

    const localId: number = osAccount.getAccountManager().getOsAccountLocalIdForUidSync(process.uid);
    log.showInfo('LocalId: %{public}d', localId);
    if (localId) {
      return '';
    } else {
      return settings.getValue(ctx, key);
    }
  }

  protected notifyValueChanged(val: T): void {
    if (this.listeners.size === 0) {
      log.showWarn('NotifyValueChanged for empty listeners');
      return;
    }

    log.showInfo('NotifyValueChanged for %{public}d listeners change to %{public}s',
      this.listeners.size, val as object);

    for (let listener of this.listeners) {
      try {
        listener(val);
      } catch (err) {
        log.showWarn('NotifyValueChanged error by %{public}s', err?.message);
      }
    }
  }
}

class VassistantAgreementController extends AbstractSettingsPropController<boolean> {
  get key(): string {
    return ASSISTANT_SWITCH_KEY;
  }

  get domain(): string {
    return settings.domainName.USER_PROPERTY;
  }

  constructor() {
    super(false);
  }

  async parseValue(): Promise<boolean> {
    let prop = await this.getValueCompletely(this.ctx, this.key, this.domain);
    log.showInfo('Agreement parseValue. get from settings is [%{public}s]', prop);

    if (prop === undefined || prop.length === 0 || prop === SETTINGS_SWITCH_OFF_PROP) {
      return false;
    } else {
      return true;
    }
  }
}

class VassistantFeatureModeController extends AbstractSettingsPropController<boolean> {
  constructor() {
    super(false);
  }

  get domain(): string {
    return settings.domainName.USER_PROPERTY;
  }

  async parseValue(): Promise<boolean> {
    const ctx = ContextManager.getTopContext();
    const prop = await this.getValueCompletely(ctx, FEATURE_MODE_KEY, this.domain);
    log.showInfo('Feature parseValue. get from settings is [%{public}s]', prop);
    return prop === SETTINGS_SWITCH_ON_PROP;
  }

  get key(): string {
    return FEATURE_MODE_KEY;
  }
}

class VassistantSearchController extends AbstractSettingsPropController<boolean> {
  constructor() {
    super(false);
  }

  get domain(): string {
    return settings.domainName.USER_PROPERTY;
  }

  async parseValue(): Promise<boolean> {
    const prop = await this.getValueCompletely(this.ctx, this.key, this.domain);
    log.showInfo('GetSearchAgreement. prop is [%{public}s]', prop);
    return prop === SETTINGS_SWITCH_ON_PROP;
  }

  get key(): string {
    return ASSISTANT_SEARCH_KEY;
  }
}
