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
import dataPreferences from '@ohos.data.preferences';
import { HashMap } from '@kit.ArkTS';
import { Context, contextConstant } from '@kit.AbilityKit';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { desktopUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';

const TAG = 'PocketPreferenceUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const recommendFromDataMultiKey = 'PocketRecommendFromDataMultiKey';
const splitKey = ',';
const desktopParam = 'DesktopParam';
// PocketInnerEditMode notify desktop
const outerPreviewSaveFlag = 'OuterPreviewSaveFlag';

/**
 * 新形态小折叠用于同步preference 外层调用处已隔离,内部不再做隔离
 */
export class PocketPreferenceUtil {
  private recommendFromData: RecommendFromData = new RecommendFromData();
  private preferences: dataPreferences.Preferences | undefined = undefined;
  private context: Context | undefined = undefined;
  private mRefreshOuterScreenFromDBFlag: boolean = false;
  private mRefreshOuterPageCacheCallBack?: Function;

  private preferenceCallback = async (key: string): Promise<void> => {
    if (key !== outerPreviewSaveFlag) {
      return;
    }
    this.setRefreshOuterScreenFromDBFlag(true);
    this.mRefreshOuterPageCacheCallBack?.();
    log.showInfo('OuterScreen need Refresh From DB');
  };

  /**
   * 类初始化
   *
   * @param context context
   */
  async init(context: Context): Promise<void> {
    log.showInfo(`init`);
    this.context = context;
    await this.getPreferences();
    this.preferences?.on('multiProcessChange', this.preferenceCallback);
  }

  public registerRefreshOuterPageCacheCallBack(callback: Function): void {
    this.mRefreshOuterPageCacheCallBack = callback;
  }

  public unRegisterRefreshOuterPageCacheCallBack(): void {
    this.mRefreshOuterPageCacheCallBack = undefined;
  }

  public setRefreshOuterScreenFromDBFlag(flag: boolean): void {
    this.mRefreshOuterScreenFromDBFlag = flag;
  }

  public getRefreshOuterScreenFromDBFlag(): boolean {
    return this.mRefreshOuterScreenFromDBFlag;
  }

  async notifyDesktop(): Promise<void> {
    log.showInfo(`notifyDesktop start`);
    try {
      await this.getPreferences();
      let mOuterPreviewSaveFlag = this.preferences?.getSync(outerPreviewSaveFlag, false) as boolean;
      this.preferences?.putSync(outerPreviewSaveFlag, !mOuterPreviewSaveFlag);
      await this.preferences?.flush();
    } catch (error) {
      log.showError(`notifyDesktop error ${error?.name}, ${error?.code}, ${error?.message}`);
    }
  }

  async getPreferences(): Promise<void> {
    log.showInfo(`getPreferences`);
    if (!this.preferences) {
      let context: Context = this.context as Context;
      let oldArea = context.area;
      context.area = contextConstant.AreaMode.EL1;
      try {
        let preferences = await dataPreferences.getPreferences(context, desktopParam);
        this.preferences = preferences;
        context.area = oldArea;
      } catch (error) {
        log.showError('getPreferences with error %{public}s', error.message);
      }
    }
  }

  /**
   * 获取推荐卡片当前桌面的权重信息 以及轮播信息等
   *
   * @returns 推荐卡片权重等信息
   */
  async getRecommendFromData(): Promise<RecommendFromData> {
    log.showInfo(`getRecommendFromData`);
    await this.getPreferences();
    let dataArr = this.preferences?.getSync(recommendFromDataMultiKey, []) as Array<string>;
    if (dataArr.length === 0) {
      log.showError(`getRecommendFromData error data from Preferences `);
      return this.recommendFromData;
    }
    this.recommendFromData.initTotal(dataArr);
    return this.recommendFromData;
  }

  /**
   * 异步刷新推荐卡片信息到preference
   *
   */
  async syncRecommendFromData(): Promise<void> {
    log.showInfo(`syncRecommendFromData start`);
    try {
      await this.getPreferences();
      this.preferences?.putSync(recommendFromDataMultiKey, this.recommendFromData.getArrayData());
      await this.preferences?.flush();
    } catch (error) {
      log.showError(`syncRecommendFromData error ${error?.name}, ${error?.code}, ${error?.message}`);
    }
  }

  /**
   * 异步刷新推荐卡片部分信息到preference
   *
   * @param lastStartIndex 轮播lastStartIndex
   * @param lastEndIndex 轮播lastEndIndex
   * @param dataSize 数据量
   */
  async setRecommendFromDataModelPart(lastStartIndex: number, lastEndIndex: number, dataSize: number): Promise<void> {
    try {
      log.showInfo(`setRecommendFromDataModelPart start`);
      this.recommendFromData.mLastStartIndex = lastStartIndex;
      this.recommendFromData.mLastEndIndex = lastEndIndex;
      this.recommendFromData.mDataSize = dataSize;
      this.syncRecommendFromData();
    } catch (error) {
      log.showError(`setRecommendFromDataModelPart error ${error?.name}, ${error?.code}, ${error?.message}`);
    }
  }

  /**
   * 异步刷新推荐卡片部分信息到preference
   *
   * @param appUsageWeight 推荐卡片刷新权重
   * @param refreshTime 推荐卡片刷新时间
   */
  async setRecommendFromDataWeightPart(appUsageWeight: HashMap<string, number>, refreshTime: number): Promise<void> {
    try {
      log.showInfo(`setRecommendFromDataWeightPart start`);
      this.recommendFromData.mAppUsageWeight = appUsageWeight;
      this.recommendFromData.mRefreshTime = refreshTime;
      this.syncRecommendFromData();
    } catch (error) {
      log.showError(`setRecommendFromDataWeightPart error ${error?.name}, ${error?.code}, ${error?.message}`);
    }
  }
}

export class RecommendFromData {
  public mAppUsageWeight: HashMap<string, number> = new HashMap();
  public mRefreshTime: number = 0;
  public mLastStartIndex: number = 0;
  public mLastEndIndex: number = 0;
  public mDataSize: number = 0;

  initTotal(dataArr: Array<string>): void {
    try {
      this.mAppUsageWeight.clear();
      for (let i = 0; i < dataArr.length; i++) {
        let item = dataArr[i];
        let itemArr = item.split(splitKey);
        if (itemArr.length < 2) {
          continue;
        }
        if (itemArr[0] === recommendFromDataMultiKey && itemArr.length >= 5) {
          this.mRefreshTime = Number(itemArr[1]);
          this.mLastStartIndex = Number(itemArr[2]);
          this.mLastEndIndex = Number(itemArr[3]);
          this.mDataSize = Number(itemArr[4]);
        } else {
          this.mAppUsageWeight.set(itemArr[0], Number(itemArr[1]));
        }
      }
    } catch (error) {
      log.showError(`RecommendFromData initTotal error ${error?.name}, ${error?.code}, ${error?.message}`);
    }
  }

  getArrayData(): string[] {
    let resultArr: string[] = [];
    this.mAppUsageWeight.forEach((value, key) => {
      resultArr.push(`${key}${splitKey}${value}`);
    });
    resultArr.push(`${recommendFromDataMultiKey}${splitKey}${this.mRefreshTime}
    ${splitKey}${this.mLastStartIndex}${splitKey}${this.mLastEndIndex}${splitKey}${this.mDataSize}`);
    return resultArr;
  }
}

export const pocketPreferenceUtil: PocketPreferenceUtil = SingletonHelper.getInstance(PocketPreferenceUtil, TAG);