/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import { AppTypeConstants } from '@ohos/commonconstants';
import systemApp from '../../resources/rawfile/system_app.json';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'AppTypeUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class AppTypeUtils {
  private static instance: AppTypeUtils;
  // 系统预制的app分类信息
  private appTypeLocalMap = new Map<string, number>();
  // app分类id对应的描述信息
  private appTypeDescMap = new Map<number, string>();

  constructor() {
    this.initAppTypeMap();
    this.initAppTypeDescMap();
  }

  static getInstance(): AppTypeUtils {
    if (!AppTypeUtils.instance) {
      AppTypeUtils.instance = new AppTypeUtils();
    }
    return AppTypeUtils.instance;
  }

  private initAppTypeDescMap(): void {
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_MEDIA, '影音');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_TOOLS, '工具');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_COMMUNICATION, '社交');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_EDUCATION, '教育');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_BOOKS, '阅读');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_PHOTOGRAPHY, '拍摄');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_FOOD, '美食');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_TRAVEL_NAVIGATION, '出行');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_TRAVEL_ACCOMMODATION, '旅游');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_SHOPPING, '购物');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_BUSINESS, '商务');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_KIDS, '儿童');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_FINANCE, '金融');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_SPORTS, '健康');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_LIFESTYLES, '生活');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_CAR, '汽车');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_PERSIONALIZED, '个性');
    this.appTypeDescMap.set(AppTypeConstants.APP_TYPE_GAME, '游戏');
    this.appTypeDescMap.set(AppTypeConstants.UNINIT_APP_TYPE, '其他应用');
  }

  private initAppTypeMap(): void {
    this.initAppTypeLocalMap();
  }

  private initAppTypeLocalMap(): void {
    let obj = JSON.parse(JSON.stringify(systemApp));
    for (let key in obj) {
      log.showDebug(`initAppTypeLocalMap, key=${key}`);
      this.appTypeLocalMap.set(key, parseInt(obj[key]));
    }
  }

  /**
   * 根据包名查询分类ID
   *
   * @param packageName 包名
   * @return app type 分类ID
   */
  queryAppTypeByPackage(packageName: string): number {
    let appType = AppTypeConstants.UNINIT_APP_TYPE;
    appType = this.appTypeLocalMap.get(packageName) ?? -1;
    return appType;
  }

  /**
   * 根据分类ID查询分类描述
   *
   * @param kindId
   * @return app type 分类ID
   */
  getAppTypeDesc(kindId: number): string {
    return this.appTypeDescMap.get(kindId);
  }
}

