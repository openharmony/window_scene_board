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

import {
  NullableType,
  Singleton,
  TsLog
} from '@ohos/themeservicebase';
import { ThemePropertyCache, ThemePropertyInfo } from '../../cache/ThemePropertyCache';
import { ThemePropertyService } from '../api/ThemePropertyService';

const TAG: string = 'ThemePropertyServiceImpl';

export class ThemePropertyServiceImpl implements ThemePropertyService {
  async modifyThemePropertyValue(id: string, property: string, defaultValue?: string): Promise<boolean> {
    TsLog.info(TAG, `modify theme property value enter id: ${id}, property: ${property}, defaultValue:${defaultValue}`);
    let themePropertyList: NullableType<ThemePropertyInfo[]> = await ThemePropertyCache.getInstance().get();
    if (!themePropertyList) {
      themePropertyList = [];
    }
    let themeProperty: ThemePropertyInfo | undefined =
      themePropertyList.find(themeProperty => themeProperty.id === id);
    let num: string | undefined;
    if (themeProperty) {
      let propertyMap: Map<string, string> = themeProperty.property;
      if (defaultValue) {
        num = defaultValue;
      } else {
        num = propertyMap.get(property);
        num = num === undefined ? '1' : (Number(num) + 1).toString();
      }
      TsLog.info(TAG, `modify theme property value enter num: ${num}`);
      propertyMap.set(property, num);
      await ThemePropertyCache.getInstance().update(themePropertyList);
      return true;
    }
    let propertyMap: Map<string, string> = new Map<string, string>();
    num = defaultValue ?? '1';
    propertyMap.set(property, num);
    let themePropertyInfo: ThemePropertyInfo = new ThemePropertyInfo(id, propertyMap);
    themePropertyList.push(themePropertyInfo);
    await ThemePropertyCache.getInstance().update(themePropertyList);
    return true;
  }

  async getThemePropertyValue(id: string, property: string): Promise<string> {
    TsLog.info(TAG, `getThemePropertyValue enter id: ${id}, property: ${property}`);
    let themePropertyList: NullableType<ThemePropertyInfo[]> = await ThemePropertyCache.getInstance().get();
    if (!themePropertyList) {
      return '';
    }
    let propertyValue: string | undefined;
    let themePropertyInfo: ThemePropertyInfo | undefined =
      themePropertyList.find(themeProperty => themeProperty.id === id);
    let propertyMap: Map<string, string> | undefined = themePropertyInfo?.property;
    propertyValue = propertyMap?.get(property);
    TsLog.info(TAG, `propertyValue: ${propertyValue}, property: ${property}`);
    return propertyValue === undefined ? '' : propertyValue;
  }

  async removeThemePropertyValue(id: string, property?: string): Promise<boolean> {
    TsLog.info(TAG, `removeThemePropertyValue enter id: ${id}, property: ${property}`);
    let themePropertyList: NullableType<ThemePropertyInfo[]> = await ThemePropertyCache.getInstance().get();
    if (!themePropertyList) {
      return false;
    }
    if (property === undefined) {
      themePropertyList = themePropertyList.filter(themePropertyInfo => themePropertyInfo.id !== id);
      await ThemePropertyCache.getInstance().update(themePropertyList);
      return true;
    }
    let themePropertyInfo: ThemePropertyInfo | undefined =
      themePropertyList.find(themeProperty => themeProperty.id === id);
    if (!themePropertyInfo) {
      return false;
    }
    let propertyMap: Map<string, string> | undefined = themePropertyInfo.property;
    if (propertyMap) {
      propertyMap.delete(property);
      if (propertyMap.size === 0) {
        themePropertyList = themePropertyList.filter(themePropertyInfo => themePropertyInfo.id !== id);
      }
    } else {
      TsLog.error(TAG, 'propertyMap is invalid');
    }
    await ThemePropertyCache.getInstance().update(themePropertyList);
    return true;
  }
}

export const themePropertyService: Singleton<ThemePropertyService> =
  new Singleton<ThemePropertyService>(() => new ThemePropertyServiceImpl());