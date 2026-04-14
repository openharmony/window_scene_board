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
import { TargetType, ThemeCode } from '@ohos/themeservice_inner_api/Index';
import { ArrayUtils, FileUtil, JsonUtils, NullableType, StringUtils, TsLog } from '@ohos/themeservicebase/Index';
import { OnlineInfo, ThemeCacheInfo, ThemeExtendInfo } from '../../cache/ThemeInfoStoreCache';
import { TSRemoteCaller } from '../../remote/caller/TSRemoteCaller';
import { createOnlineThemeInfo, getContentPrivStatus, OnlineThemeInfo } from '../../remote/model/OnlineThemeInfo';
import { NotifyUpdateScene, ThemeVipService, NOTIFY_UPDATE_SCENE_THEME } from '../api/ThemeVipService';
import { themeInfoService } from './ThemeInfoServiceImpl';
import { ActivatedThemeUtil } from '../../util/ActivatedThemeUtil';
import { APP_THEME_TYPE_LIST, SYSTEM_THEME_TYPE_LIST } from '@ohos/themeservice_inner_api/src/main/ets/constant/TSTypes';

const TAG: string = 'ThemeVipServiceImpl';
/**
 * 资源不可用
 */
const CONTENT_TYPE_DISABLE: number = 0;

/**
 * 主题会员资源服务具体实现，非单例
 */
export class ThemeVipServiceImpl implements ThemeVipService {
  async getOnlineThemeList(): Promise<Nullable<OnlineThemeInfo[]>> {
    let themeCacheList: NullableType<ThemeCacheInfo[]> = themeInfoService.get().getCacheThemeList();
    if (!themeCacheList) {
      TsLog.info(TAG, `getOnlineThemeList themeCacheList is null`);
      return undefined;
    }
    let onlineThemeMap: Map<string, OnlineThemeInfo> = new Map();
    themeCacheList.forEach((infoItem: ThemeCacheInfo) => {
      this.handelThemeCacheInfo(infoItem, onlineThemeMap);
    });
    if (onlineThemeMap.size === 0) {
      TsLog.info(TAG, `getOnlineThemeList onlineThemeMap is null`);
      return undefined;
    }
    TsLog.info(TAG, `getOnlineThemeList size = ${onlineThemeMap.size}`);
    return Array.from(onlineThemeMap.values());
  }

  /**
   * 是否有资源变更
   * @param tag 资源类型 app | system
   * @returns
   */
  async hasResourceUpdate(tag: string): Promise<boolean> {
    const activatedPathA = `${ActivatedThemeUtil.getActivatedPathA()}${tag}`;
    const activatedPathB = `${ActivatedThemeUtil.getActivatedPathB()}${tag}`;
    // 对比主题包
    if (await this.isThemeDescriptionChanged(`${activatedPathA}/description.json`,
      `${activatedPathB}/description.json`)) {
      return true;
    }
    let onlineTypeList = (tag === 'system') ? SYSTEM_THEME_TYPE_LIST : APP_THEME_TYPE_LIST;
    for (let type of onlineTypeList) {
      const aFilePath = `${activatedPathA}/${type}/description.json`;
      const bFilePath = `${activatedPathB}/${type}/description.json`;
      if (await this.isThemeDescriptionChanged(aFilePath, bFilePath)) {
        return true;
      }
      if (type === 'skin') {
        const aSkinFileNameList = await FileUtil.listFileNames(`${activatedPathA}/${type}`);
        const bSkinFileNameList = await FileUtil.listFileNames(`${activatedPathB}/${type}`);
        let skinFileNameSet: Set<string> = new Set(aSkinFileNameList.concat(bSkinFileNameList));
        for (let skinFileName of skinFileNameSet) {
          const aSkinFilePath = `${activatedPathA}/${type}/${skinFileName}/description.json`;
          const bSkinFilePath = `${activatedPathB}/${type}/${skinFileName}/description.json`;
          if (await this.isThemeDescriptionChanged(aSkinFilePath, bSkinFilePath)) {
            return true;
          }
        }
        const aNewSkinFileNameList = await FileUtil.listFileNames(`${ActivatedThemeUtil.getActivatedPathA()}${type}`);
        const bNewSkinFileNameList = await FileUtil.listFileNames(`${ActivatedThemeUtil.getActivatedPathB()}${type}`);
        let newSkinFileNameSet: Set<string> = new Set(aNewSkinFileNameList.concat(bNewSkinFileNameList));
        for (let skinFileName of newSkinFileNameSet) {
          const aSkinFilePath = `${ActivatedThemeUtil.getActivatedPathA()}${type}/${skinFileName}/description.json`;
          const bSkinFilePath = `${ActivatedThemeUtil.getActivatedPathB()}${type}/${skinFileName}/description.json`;
          if (await this.isThemeDescriptionChanged(aSkinFilePath, bSkinFilePath)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /**
   * 从description中查找资源的变更情况
   * @param pathA a目录的description
   * @param pathB b目录的description
   * @returns 资源是否有变更
   */
  async isThemeDescriptionChanged(pathA: string, pathB: string): Promise<boolean> {
    try {
      let contentA: string = '';
      let contentB: string = '';
      if (FileUtil.isFileExists(pathA)) {
        contentA = await FileUtil.readFileContent(pathA);
      }
      if (FileUtil.isFileExists(pathB)) {
        contentB = await FileUtil.readFileContent(pathB);
      }
      if (StringUtils.isEmpty(contentA) && StringUtils.isEmpty(contentB)) {
        return false;
      }
      if (!StringUtils.isEmpty(contentA) && !StringUtils.isEmpty(contentB)) {
        const descriptionA: object = JSON.parse(contentA);
        const descriptionB: object = JSON.parse(contentB);
        if (descriptionA && descriptionB) {
          return descriptionA['id'] !== descriptionB['id'];
        }
      }
      return true;
    } catch (err) {
      TsLog.warning(TAG, `isThemeDescriptionChanged err: ${err}`);
    }
    return true;
  }

  /**
   * 处理主题缓存信息，得到在线资源信息，并加入到在线资源Map中
   * @param themeCacheInfo 待处理的主题缓存信息
   * @param onlineThemeMap 待加入的在线资源Map
   */
  private handelThemeCacheInfo(themeCacheInfo: ThemeCacheInfo, onlineThemeMap: Map<string, OnlineThemeInfo>): void {
    // 当前主题是在线主题，获取当前主题id
    if (themeCacheInfo && themeCacheInfo.originType === 'online') {
      let onlineThemeInfo: OnlineThemeInfo =
        createOnlineThemeInfo(themeCacheInfo.id, 'theme', themeCacheInfo.onlineInfo?.contentPrivStatus)
      onlineThemeMap.set(themeCacheInfo.id, onlineThemeInfo);
    }
    // 当前主题中包含在线资源，获取当前主题在线资源id
    if (themeCacheInfo && themeCacheInfo.themeEditInfo && themeCacheInfo.themeEditInfo.size > 0) {
      themeCacheInfo.themeEditInfo.forEach((extendInfoItem: ThemeExtendInfo, target: TargetType) => {
        if (extendInfoItem && extendInfoItem.type === 'online') {
          let onlineThemeInfo: OnlineThemeInfo =
            createOnlineThemeInfo(extendInfoItem.resourceId, target, extendInfoItem.onlineInfo?.contentPrivStatus)
          onlineThemeMap.set(extendInfoItem.resourceId, onlineThemeInfo);
        }
      });
    }
  }

  async updateOnlineTheme(onlineThemeInfos: OnlineThemeInfo[], vipExpirationDate: number): Promise<number> {
    if (TsLog.isDebug(TAG)) {
      TsLog.info(TAG, `updateOnlineTheme start , infos = ${JsonUtils.stringify(onlineThemeInfos)}`);
    } else {
      TsLog.info(TAG, `updateOnlineTheme start , infos size = ${onlineThemeInfos?.length}`);
    }
    if (!onlineThemeInfos || ArrayUtils.isNull(onlineThemeInfos)) {
      TsLog.info(TAG, `updateOnlineTheme success , onlineThemes is null`);
      return ThemeCode.SUCCESS;
    }
    let themeCacheList: NullableType<ThemeCacheInfo[]> = themeInfoService.get().getCacheThemeList();
    if (!themeCacheList) {
      TsLog.info(TAG, `updateOnlineTheme success , themeCacheList is null`);
      return ThemeCode.SUCCESS;
    }
    let onlineThemeInfoMap: Map<string, OnlineThemeInfo> = new Map();
    onlineThemeInfos.forEach((onlineItem: OnlineThemeInfo) => {
      if (onlineItem && !StringUtils.isEmpty(onlineItem.id)) {
        onlineThemeInfoMap.set(onlineItem.id, onlineItem);
      }
    });
    themeCacheList.forEach((infoItem: ThemeCacheInfo) => {
      this.updateThemeCacheInfo(infoItem, onlineThemeInfoMap, vipExpirationDate);
    });
    await themeInfoService.get().updateCacheThemeList(themeCacheList);
    TsLog.info(TAG, `updateOnlineTheme success , theme size = ${themeCacheList.length}`);
    return ThemeCode.SUCCESS;
  }

  /**
   * 从主题App返回的在线资源Map中，获取在线资源，更新主题缓存信息
   * @param themeCacheInfo 待更新的主题缓存信息
   * @param onlineThemeInfoMap 主题App返回的在线资源Map
   * @param vipExpirationDate 会员到期时间
   */
  private updateThemeCacheInfo(themeCacheInfo: ThemeCacheInfo,
    onlineThemeInfoMap: Map<string, OnlineThemeInfo>,
    vipExpirationDate: number): void {
    // 更新当前在线主题信息
    if (themeCacheInfo && themeCacheInfo.originType === 'online' && onlineThemeInfoMap.has(themeCacheInfo.id)) {
      themeCacheInfo.onlineInfo =
        new OnlineInfo(vipExpirationDate, getContentPrivStatus(onlineThemeInfoMap.get(themeCacheInfo.id)));
    }
    // 更新当前主题在线资源信息
    if (themeCacheInfo && themeCacheInfo.themeEditInfo && themeCacheInfo.themeEditInfo.size > 0) {
      themeCacheInfo.themeEditInfo.forEach((extendInfoItem: ThemeExtendInfo) => {
        if (extendInfoItem && extendInfoItem.type === 'online' && onlineThemeInfoMap.has(extendInfoItem.resourceId)) {
          extendInfoItem.onlineInfo =
            new OnlineInfo(vipExpirationDate, getContentPrivStatus(onlineThemeInfoMap.get(extendInfoItem.resourceId)));
        }
      });
    }
  }

  async notifyUpdateOnlineTheme(isNeedClean: boolean, scene: NotifyUpdateScene): Promise<void> {
    TsLog.info(TAG, `notifyUpdateOnlineTheme start , scene = ${scene}`);
    let onlineThemeList: Nullable<OnlineThemeInfo[]> = await this.getOnlineThemeList();
    if (onlineThemeList && onlineThemeList.length > 0) {
      if (isNeedClean) {
        await this.cleanOnlineTheme(onlineThemeList);
      }
      TsLog.info(TAG, `notifyUpdateOnlineTheme end , size = ${onlineThemeList?.length}`);
      try {
        await TSRemoteCaller.notifyUpdateOnlineTheme(scene, onlineThemeList);
      } catch (e) {
        TsLog.warning(TAG, `notifyUpdateOnlineTheme error`, e);
      }
      return;
    }
    // 非在线主题，有资源变更，需要通知主题app进行结算
    if (scene !== NOTIFY_UPDATE_SCENE_THEME) {
      return;
    }
    if (await this.hasResourceUpdate(ActivatedThemeUtil.APP) ||
      await this.hasResourceUpdate(ActivatedThemeUtil.SYSTEM)) {
      TsLog.info(TAG, 'hasResourceUpdate');
      try {
        await TSRemoteCaller.notifyUpdateOnlineTheme(scene, []);
      } catch (e) {
        TsLog.warning(TAG, `notifyUpdateOnlineTheme error`, e);
      }
    }
  }

  /**
   * 清理在线资源会员信息，重置全部在线资源为不可用状态 0：disable
   */
  private async cleanOnlineTheme(onlineThemeList: OnlineThemeInfo[]): Promise<void> {
    TsLog.info(TAG, `clearOnlineTheme start`);
    onlineThemeList.forEach((item: OnlineThemeInfo) => {
      if (item) {
        // 重置为不可用状态 0：disable
        item.contentPrivStatus = CONTENT_TYPE_DISABLE
      }
    });
    // 更新缓存，并重置会员到期时间为0
    await this.updateOnlineTheme(onlineThemeList, 0);
    TsLog.info(TAG, `clearOnlineTheme end`);
  }
}

/**
 * 会员服务，创建实现类，非单例
 * @returns {ThemeVipService} 会员服务实现
 */
export function themeVipService(): ThemeVipService {
  return new ThemeVipServiceImpl();
}