/**
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';

const INTENT_COMPONENT_KEY: string = 'component';
const INTENT_SHORTCUT_ID: string = 'shortcut_id';
const CONNECT_SYMBOL: string = '_';
const ONEKEYLOCK_SHORTCUT_PACKAGE_NAME: string = 'com.ohos.systemui';
const ONEKEYLOCK_SHORTCUT_ACTIVITY_NAME: string = 'com.openharmony.keyguard.onekeylock.shortcut.ApproachActivity';
const ONEKEYLOCK_PACKAGE_NAME: string = 'com.openharmony.hwonekeylock';

export interface PackageRelation {
  packageName: string;
  className: string;
  shortcutId: string;
}

const TAG = 'IntentParseUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class IntentParseUtil {
  public static readonly KEY_FORM_NAME: string = 'ohos.extra.param.key.form_name';
  public static readonly SHORTCUT_TO_APP_MAP: Map<string, string> = new Map([
    [ONEKEYLOCK_SHORTCUT_PACKAGE_NAME + CONNECT_SYMBOL + ONEKEYLOCK_SHORTCUT_ACTIVITY_NAME, ONEKEYLOCK_PACKAGE_NAME]
  ]);

  // used to replace intent parse prefix
  private static intentTypePrefix: string[] = [
    'S.', // string
    'B.', // boolean
    'b.', // byte
    'c.', //char
    'd.', //double
    'f.', // float
    'i.', // int
    'l.', // long
    's.', // short
  ];

  /**
   * used to parse intentStr to map
   * @param intentStr database intent str
   * @returns parse intent map
   */
  static parseIntent(intentStr: string): Map<string, string> {
    let map: Map<string, string> = new Map();
    intentStr = decodeURI(intentStr);
    if (intentStr) {
      let intentArr: string[] = intentStr.split(';');
      if (intentStr && intentStr.length > NumberConstants.CONSTANT_NUMBER_TWO) {
        for (let i = 1; i < intentArr.length - 1; i++) {
          let keyValueArr: string[] = intentArr[i].split('=');
          if (intentStr && keyValueArr.length === NumberConstants.CONSTANT_NUMBER_TWO) {
            let key = keyValueArr[0];
            if (!key) {
              continue;
            }
            key = IntentParseUtil.replaceTypePrefix(key);
            map.set(key, keyValueArr[1]);
          }
        }
      }
    }
    return map;
  }

  /**
   * used to parse packageName and className from intentStr
   * @param intentStr database intent str
   * @returns packageName and className by parse intent
   */
  static getComponentByIntent(intentStr: string): PackageRelation | null {
    let intentParseMap: Map<string, string> = IntentParseUtil.parseIntent(intentStr);
    if (!intentParseMap || intentParseMap.size === 0) {
      return null;
    }
    let componentStr: string = intentParseMap.get(INTENT_COMPONENT_KEY) ?? '';
    let shortcutId: string = intentParseMap.get(INTENT_SHORTCUT_ID) ?? '';
    return IntentParseUtil.getByRelationComponentStr(componentStr, shortcutId);
  }

  static getByRelationComponentStr(componentStr: string, shortcutId: string = ''): PackageRelation | null {
    if (!componentStr) {
      return null;
    }
    let componentArr: string[] = componentStr.split('/');
    if (componentArr.length !== NumberConstants.CONSTANT_NUMBER_TWO) {
      return null;
    }
    let packageName: string = componentArr[0];
    let className: string = componentArr[1];
    if (className && className.startsWith('.')) {
      className = packageName + className;
    }
    return { className, packageName, shortcutId };
  }

  private static replaceTypePrefix(key: string): string {
    for (let item of IntentParseUtil.intentTypePrefix) {
      if (key && key.startsWith(item)) {
        return key.replace(item, '');
      }
    }
    return key;
  }

  static isRetainedShortcut(intentStr: string): boolean {
    return !CheckEmptyUtils.checkStrIsEmpty(IntentParseUtil.queryShortcutToAppMappingPackageName(intentStr));
  }

  static queryShortcutToAppMappingPackageName(intentStr: string): string {
    let packageName: string = '';
    let packageRelation: PackageRelation | null = IntentParseUtil.getComponentByIntent(intentStr);
    if (!packageRelation) {
      log.showWarn('shortcut has no mapping relation, intentStr = %{public}s', intentStr);
      return packageName;
    }
    let shortcutKey: string = packageRelation.packageName + CONNECT_SYMBOL + packageRelation.className;
    if (IntentParseUtil.SHORTCUT_TO_APP_MAP.has(shortcutKey)) {
      packageName = IntentParseUtil.SHORTCUT_TO_APP_MAP.get(shortcutKey) ?? '';
    }
    log.showInfo('shortcut to app, packageName = %{public}s', packageName);
    return packageName;
  }
}