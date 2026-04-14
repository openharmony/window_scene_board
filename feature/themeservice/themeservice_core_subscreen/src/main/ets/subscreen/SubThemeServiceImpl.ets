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

import List from '@ohos.util.List';
import { EventEmitter, FileUtil, NullableType, ObjectUtils, StringUtils, TsLog, JsonUtils } from '@ohos/themeservicebase';
import { TsSubScreenCache } from './TsSubScreenCache';
import { Constants, EventId, ThemeInfo, ThemeOptions, TServiceApi, ActivateEventData } from '@ohos/themeservice_inner_api';

import { SubThemeService } from './SubThemeService';
import { SubScreenInfo, TYPE_COMBINED, TYPE_INDEPENDENT } from './SubScreenInfo';
import { systemDateTime } from '@kit.BasicServicesKit';
import configPolicy from '@ohos.configPolicy';
import { SubThemeUtil } from './SubThemeUtil';
import { SubThemeDescriptionInfo } from './SubThemeDescriptionInfo';
import { COVER_DIR, SubThemeHelper, SUM_THEME_PATH, THEME_ROOT_DIR } from './SubThemeHelper';
import commonEventManager from '@ohos.commonEventManager';

const TAG: string = 'SubThemeServiceImpl';

/**
 * 主题包description.json名称
 */
const SUB_SCREEN_DIR: string = '/sub_screen';

const FILE_SEPARATOR: string = '/';

/**
 * 画廊最少需要1个主题
 */
const LEAST_LENGTH: number = 1;

/**
 * 主题包description.json名称
 */
const DESCRIPTION: string = 'description.json';

/**
 * 主题包的相对路径
 */
const THEME_PKG_DIR: string = 'resource/themes/theme';

/**
 * 贴纸主题资源id列表
 */
const STICKER_ORIGIN_ID_LIST: string[] = ['2180621725', '2180997063', '2180997263'];

const MANIFEST_SUBSCREEN: string = '/manifest_subscreen.json';

const MANIFEST: string = '/manifest.json';

/**
 * 外屏主题最大数量
 */
const MAX_GALLERY_COUNT: number = 30;

const PANDORA_ORIGIN_ID: string = '2180701625';

/**
 * 自选图片description Id
 */
const CUSTOM_WALLPAPER_ID: string = 'CUSTOM_AESTHETIC_00001';

/**
 * 主题包来源类型
 */
const ORIGIN_TYPE_PRESET: string = 'preset';

const ORIGIN_TYPE_PRESET_FRAGMENT: string = 'presetFragment';

const ORIGIN_TYPE_ONLINE: string = 'online';

/**
 * @description 主题数据业务
 */
export class SubThemeServiceImpl implements SubThemeService {
  private lastEnableTheme: number = 0;
  private serviceHasInit: boolean = false;
  private userSubScreenThemeList: List<SubScreenInfo> = new List<SubScreenInfo>();
  private editorIdMap: Map<string, string> = new Map();
  private presetThemeIdPathMap: Map<string, string> = new Map();
  private presetThemeIdOriginMap: Map<string, string> = new Map();
  private presetSubScreenThemes: string[] = [];
  private presetSuiteThemes: string[] = [];
  private defaultThemeId: string = '';
  private needUpdateSuiteEditorId: boolean = false;
  private secondMountSubscriber: commonEventManager.CommonEventSubscriber | undefined;// 二次挂载
  private cachedSubThemeInfoList: NullableType<List<SubScreenInfo>>;

  /**
   * 应用外屏主题
   * @param subScreenTheme 外屏主题信息
   * @returns 是否应用成功
   */
  async onSubThemeActivated(subScreenTheme: SubScreenInfo): Promise<boolean> {
    TsLog.info(TAG, `onSubThemeActivated: ${subScreenTheme.themeId}`);
    let shouldAdd: boolean = true;
    let currentSubScreenTheme: SubScreenInfo = subScreenTheme;
    let currentEnableIndex: number = -1;
    this.userSubScreenThemeList.forEach((theme: SubScreenInfo, index: number) => {
      if (theme.themeId === currentSubScreenTheme.themeId) {
        shouldAdd = false;
        currentSubScreenTheme.order = theme.order;
        currentSubScreenTheme.type = theme.type;
        currentSubScreenTheme.origin = theme.origin;
        currentSubScreenTheme.isSuite = theme.isSuite;
        currentEnableIndex = index;
        currentSubScreenTheme.suiteEditorId = theme.suiteEditorId;
        currentSubScreenTheme.isCustom = theme.isCustom;
      }
    })
    currentEnableIndex = currentEnableIndex < 0 ? this.userSubScreenThemeList.length : currentEnableIndex;
    let activateResult: boolean = await this.activate(currentSubScreenTheme);
    if (activateResult) {
      if (shouldAdd) {
        currentSubScreenTheme.order = this.getMinUnusedOrder(subScreenTheme.originId);
        currentSubScreenTheme.origin = this.getSubThemeOrigin(currentSubScreenTheme);
        this.userSubScreenThemeList.add(currentSubScreenTheme);
        if (this.tryDeleteOldestTheme()) {
          currentEnableIndex--;
        }
      } else {
        this.userSubScreenThemeList[currentEnableIndex] = currentSubScreenTheme;
      }
      this.userSubScreenThemeList.forEach((theme: SubScreenInfo) => {
        theme.isEnabled = false;
      })
      this.lastEnableTheme = currentEnableIndex;
      this.userSubScreenThemeList.get(this.lastEnableTheme).isEnabled = true;
      this.subScreenUpdate();
    }
    TsLog.info(TAG, `activateResult: ${activateResult}`);
    return activateResult;
  }

  private getSubThemeOrigin(subScreenInfo: SubScreenInfo): string {
    if (this.presetThemeIdOriginMap.has(subScreenInfo.originId)) {
      return this.presetThemeIdOriginMap.get(subScreenInfo.originId) ?? ORIGIN_TYPE_PRESET;
    }
    let path: string = subScreenInfo.path;
    if (path && FileUtil.isFileExists(path + FILE_SEPARATOR + DESCRIPTION)) {
      let content: string = FileUtil.getStringByFile(path + FILE_SEPARATOR + DESCRIPTION);
      if (!content) {
        return ORIGIN_TYPE_PRESET;
      }
      let json: object | undefined = JsonUtils.parse(content);
      return (json && json['origin']) ? json['origin'] : ORIGIN_TYPE_PRESET;
    }
    return ORIGIN_TYPE_PRESET;
  }

  public async removeOnlineSubThemes(): Promise<void> {
    let screenInfoList: List<SubScreenInfo> = new List<SubScreenInfo>();
    this.userSubScreenThemeList.forEach((subScreenInfo) => {
      if (subScreenInfo.origin === ORIGIN_TYPE_PRESET) {
        screenInfoList.add(subScreenInfo);
      } else {
        if (FileUtil.isFileExists(subScreenInfo.customPath)) {
          FileUtil.rmdirAsync(subScreenInfo.customPath);
        }
      }
    })
    this.userSubScreenThemeList.clear();
    this.userSubScreenThemeList = screenInfoList;
    await this.subScreenUpdate();
  }

  /**
   * 外屏画廊中主题新增
   * @param subScreenTheme 新增的外屏主题信息
   * @returns 当前的外屏主题列表
   */
  onSubThemeAdded(subScreenTheme: SubScreenInfo): SubScreenInfo[] {
    TsLog.info(TAG, `onSubThemeAdded themeId: ${subScreenTheme.themeId}`);
    for (let i = 0; i < this.userSubScreenThemeList.length; i++) {
      if (this.userSubScreenThemeList[i].themeId === subScreenTheme.themeId) {
        this.userSubScreenThemeList[i] = subScreenTheme;
        this.subScreenUpdate();
        return this.userSubScreenThemeList.convertToArray();
      }
    }
    subScreenTheme.order = this.getMinUnusedOrder(subScreenTheme.originId);
    this.userSubScreenThemeList.add(subScreenTheme);
    this.subScreenUpdate();
    return this.userSubScreenThemeList.convertToArray();
  }

  /**
   * 外屏画廊中主题被删除
   * @param themeId 删除的主题id
   * @returns 当前的外屏主题列表
   */
  onSubThemeDeleted(themeId: string): SubScreenInfo[] {
    this.deleteSubThemeByThemeId(themeId);
    return this.userSubScreenThemeList.convertToArray();
  }

  deleteSubThemeByThemeId(themeId: string) {
    if (StringUtils.isEmpty(themeId)) {
      TsLog.error(TAG, 'onSubThemeDeleted error themeId is empty');
      return;
    }
    TsLog.info(TAG, `onSubThemeDeleted themeId: ${themeId}`);
    if (this.userSubScreenThemeList.length <= LEAST_LENGTH) {
      TsLog.warning(TAG, `The list requires at least one theme`);
      return;
    }
    let deleteTheme: SubScreenInfo | undefined;
    this.userSubScreenThemeList.forEach((theme: SubScreenInfo, index: number) => {
      if (theme.themeId === themeId && !theme.isEnabled) {
        deleteTheme = theme;
        if (index < this.lastEnableTheme) {
          this.lastEnableTheme = this.lastEnableTheme - 1;
        }
      }
    })
    if (deleteTheme) {
      this.userSubScreenThemeList.remove(deleteTheme);
      if (FileUtil.isFileExists(deleteTheme.customPath)) {
        FileUtil.rmdirAsync(deleteTheme.customPath);
      }
    }
    this.subScreenUpdate();
  }

  getMinUnusedOrder(originId: string): number {
    let order: number = 0;
    let userOrders: number[] = [];
    if (STICKER_ORIGIN_ID_LIST.includes(originId)) {
      this.userSubScreenThemeList.forEach((subInfo: SubScreenInfo) => {
        if (STICKER_ORIGIN_ID_LIST.includes(subInfo.originId)) {
          userOrders.push(subInfo.order);
        }
      })
    } else {
      this.userSubScreenThemeList.forEach((subInfo: SubScreenInfo) => {
        if (subInfo.originId === originId) {
          userOrders.push(subInfo.order);
        }
      })
    }

    userOrders.sort((order1: number, order2: number) => {
      return order1 - order2;
    });
    userOrders.forEach(usedOrder => {
      if (order === usedOrder) {
        order++;
      }
    })
    return order;
  }

  async reset(): Promise<void> {
    TsLog.info(TAG, `reset sub screen themes start`);
    this.editorIdMap.clear();
    this.userSubScreenThemeList.clear();
    TsSubScreenCache.getInstance().setIsFirstInit(true);
    await FileUtil.trimDirAsync(SUM_THEME_PATH);
    let subScreenInfoList = await TsSubScreenCache.getInstance().initDefaultSubTheme();
    if (subScreenInfoList && subScreenInfoList.length > 0) {
      this.userSubScreenThemeList.add(subScreenInfoList[0]);
    }
    let themeList: NullableType<ThemeInfo[]> = await TServiceApi.themeInfoInner().getCurrentInnerThemeInfoList(0);
    if (themeList) {
      this.onAllPresetsTheme(themeList)
    }
  }

  /**
   * 解析所有主题包信息
   * @return {Promise<ThemePackInfo[]>} 返回一个Promise，其解析结果为ThemePackInfo数组
   */
  async parseAllManifests(): Promise<void> {
    TsLog.info(TAG, `parseAll start`);
    try {
      // 遍历主题类别数组，得到预置主题数组
      const presetThemePathList: string[] = await configPolicy.getCfgFiles(THEME_PKG_DIR);
      presetThemePathList.sort();
      for (const presetThemeRootPath of presetThemePathList) {
        // 从manifest.json文件中获取主题清单，将主题清单解析为ThemeCategory数组
        this.parseManifest(presetThemeRootPath + '/manifest.json', presetThemeRootPath, true);
        this.parseManifest(presetThemeRootPath + '/manifest_subscreen.json', presetThemeRootPath, false);
      }
    } catch (error) {
      TsLog.error(TAG, `parseAll failed , error = ${error}`);
    }
  }

  /**
   * 解析所有外屏主题包信息
   * @return {Promise<List<SubScreenInfo>>} 返回一个Promise，其解析结果为List<SubScreenInfo>
   */
  async parseAllSubScreen(initInnerTheme: NullableType<ThemeInfo>,
    themeInfo: ThemeInfo[]): Promise<Nullable<List<SubScreenInfo>>> {
    TsLog.info(TAG, `parseAllSubScreen start`);
    try {
      // 遍历主题类别数组，得到预置主题数组
      let subScreenInfoList: List<SubScreenInfo> = new List();
      const presetThemePathList: string[] = await configPolicy.getCfgFiles(THEME_PKG_DIR);
      const idEditorIdMap: Map<string, string> = new Map();
      let themeList: NullableType<ThemeInfo[]> = themeInfo;
      themeList?.forEach((themeInfo) => {
        idEditorIdMap.set(themeInfo.id, themeInfo.editorId);
      })
      for (const presetThemeRootPath of presetThemePathList) {
        // manifest_subscreen.json文件中获取外屏独有主题清单，将其解析为ThemeCategory数组
        let subThemeCategoryArray: ThemeCategory[] | undefined =
          this.getThemeCategory(presetThemeRootPath, MANIFEST_SUBSCREEN);
        if (!subThemeCategoryArray) {
          TsLog.error(TAG, 'parseAllSubScreen is null');
          continue;
        }
        subScreenInfoList = await this.parseUniqueSubScreen(subThemeCategoryArray, presetThemeRootPath);
        // manifest_subscreen.json文件中获取外屏独有主题清单，将其解析为ThemeCategory数组
        let themeCategoryArray: ThemeCategory[] | undefined = this.getThemeCategory(presetThemeRootPath, MANIFEST);
        if (!themeCategoryArray) {
          TsLog.error(TAG, 'parseAllSubScreen is null');
          continue;
        }
        for (let themeCategory of themeCategoryArray) {
          if (themeCategory.dir && themeCategory.dir.length > 0) {
            await this.parseSubScreenDescription(themeCategory, presetThemeRootPath, subScreenInfoList, idEditorIdMap,
              initInnerTheme);
          }
        }
      }
      return subScreenInfoList;
    } catch (error) {
      TsLog.error(TAG, `parseAllSubScreen failed , error = ${error}`);
      return undefined;
    }
  }

  private getThemeCategory(presetThemeRootPath: string, path: string): ThemeCategory[] | undefined {
    const themeManifest: string = FileUtil.getStringByFile(`${presetThemeRootPath}${path}`);
    const themeCategoryArray: ThemeCategory[] | undefined = JsonUtils.parse(themeManifest);
    if (!themeCategoryArray || themeCategoryArray.length === 0) {
      TsLog.error(TAG, 'themeCategoryArray is null');
      return undefined;
    }
    return themeCategoryArray;
  }

  private async parseUniqueSubScreen(subThemeCategoryArray: ThemeCategory[],
    presetThemeRootPath: string): Promise<List<SubScreenInfo>> {
    let subScreenInfoList: List<SubScreenInfo> = new List();
    for (let subThemeCategory of subThemeCategoryArray) {
      if (!subThemeCategory.dir || subThemeCategory.dir.length <= 0) {
        continue;
      }
      for (let themeDir of subThemeCategory.dir) {
        let subThemePath: string = `${presetThemeRootPath}/${themeDir.theme}${SUB_SCREEN_DIR}`;
        TsLog.info(TAG, `parseSubScreenDescription: ${themeDir.theme}`);
        if (FileUtil.isFileExists(subThemePath)) {
          if (FileUtil.isFileExists(subThemePath + '/description.json')) {
            let content: string = FileUtil.getStringByFile(subThemePath + '/description.json');
            let json: SubThemeDescriptionInfo = JSON.parse(content);
            if (json.origin === ORIGIN_TYPE_PRESET_FRAGMENT) {
              // 半预置主题, 初始化时不显示
              continue;
            }
          }
          let index = subScreenInfoList.length;
          let subThemeId = (++index).toString();
          const targetDir: string = `${SUM_THEME_PATH}${subThemeId}`;
          TsLog.info(TAG, `parseSubScreen targetDir: ${targetDir}`);
          FileUtil.copyDirAsync(`${subThemePath}`, `${targetDir}`).then((copyRet) => {
            if (!copyRet) {
              TsLog.warning(TAG, `copy fail src: ${subThemePath}`);
            } else {
              SubThemeUtil.checkThemePackage(subThemeId.toString(), targetDir + SUB_SCREEN_DIR)
            }
          });
          let subScreenInfo: SubScreenInfo =
            new SubScreenInfo(themeDir.theme_id, subThemeId, subThemePath, targetDir + SUB_SCREEN_DIR);
          subScreenInfo.type = TYPE_INDEPENDENT;
          if (STICKER_ORIGIN_ID_LIST.includes(themeDir.theme_id)) {
            subScreenInfo.order = STICKER_ORIGIN_ID_LIST.indexOf(themeDir.theme_id);
          }
          subScreenInfoList.add(subScreenInfo);
        }
      }

    }
    return subScreenInfoList;
  }

  private async parseSubScreenDescription(themeCategory: ThemeCategory,
    presetThemeRootPath: string,
    subScreenInfoList: List<SubScreenInfo>,
    idEditorIdMap: Map<string, string>,
    initInnerTheme: NullableType<ThemeInfo>): Promise<void> {
    TsLog.info(TAG, 'parseSubScreenDescription start');
    for (let themeDir of themeCategory.dir) {
      let subThemePath: string = `${presetThemeRootPath}/${themeDir.theme}${SUB_SCREEN_DIR}`;
      TsLog.info(TAG, `parseSubScreenDescription: ${themeDir.theme}`);
      if (FileUtil.isFileExists(subThemePath)) {
        if (themeDir.theme_id) {
          await this.parseSubScreen(themeDir.theme_id, subThemePath, idEditorIdMap, subScreenInfoList, initInnerTheme);
        }
      }
    }
  }

  private async parseSubScreen(themeId: string, subThemePath: string, idEditorIdMap: Map<string, string>,
    subScreenInfoList: List<SubScreenInfo>, initInnerTheme: NullableType<ThemeInfo>): Promise<void> {
    let originId: string = themeId;
    if (!idEditorIdMap.has(originId)) {
      TsLog.error(TAG, 'originId is null or undefined');
      return;
    }
    let editorId: string | undefined = idEditorIdMap.get(originId);
    if (!editorId) {
      let index = subScreenInfoList.length;
      editorId = (++index).toString();
    }
    if (initInnerTheme?.id === originId) {
      this.editorIdMap.set(initInnerTheme.editorId, '0000000000000');
      return;
    }
    let index = subScreenInfoList.length;
    let subThemeId = ++index;
    const targetDir: string = `${SUM_THEME_PATH}${subThemeId}`;
    TsLog.info(TAG, `parseSubScreen targetDir: ${targetDir}`);
    FileUtil.copyDirAsync(`${subThemePath}`, `${targetDir}`).then((copyRet) => {
      if (!copyRet) {
        TsLog.warning(TAG, `copy fail src: ${subThemePath}`);
      } else {
        SubThemeUtil.checkThemePackage(subThemeId.toString(), targetDir + SUB_SCREEN_DIR)
      }
    });
    let subScreenInfo: SubScreenInfo =
      new SubScreenInfo(originId, subThemeId.toString(), subThemePath, targetDir + SUB_SCREEN_DIR);
    subScreenInfo.type = TYPE_COMBINED;
    subScreenInfo.isEnabled = false;
    subScreenInfo.isSuite = true;
    subScreenInfo.suiteEditorId = idEditorIdMap.get(originId) ?? '';
    if (FileUtil.isFileExists(subThemePath + '/description.json')) {
      let content: string = FileUtil.getStringByFile(subThemePath + '/description.json');
      let json: SubThemeDescriptionInfo = JSON.parse(content);
      if (json.origin === ORIGIN_TYPE_PRESET_FRAGMENT) {
        // 半预置主题, 初始化时不显示
        return;
      }
    }
    subScreenInfoList.add(subScreenInfo);
    this.editorIdMap.set(editorId, subThemeId.toString());
  }

  private parseManifest(themeManifestPath: string, presetThemeRootPath: string, isSutie: boolean): void {
    const themeManifest: string = FileUtil.getStringByFile(themeManifestPath);
    if (themeManifest === '') {
      TsLog.error(TAG, `manifest_subscreen is null`);
      return;
    }
    const themeCategoryArray: ThemeCategory[] | undefined = JsonUtils.parse(themeManifest);
    if (!themeCategoryArray || themeCategoryArray.length === 0) {
      TsLog.error(TAG, `parseAll is null`);
      return;
    }
    for (let themeCategory of themeCategoryArray) {
      if (themeCategory.dir && themeCategory.dir.length > 0) {
        this.handleThemeCategory(themeCategory, presetThemeRootPath, isSutie);
      }
    }
  }

  private handleThemeCategory(themeCategory: ThemeCategory, presetThemeRootPath: string, isSuite: boolean): void {
    for (let themeDir of themeCategory.dir) {
      let subThemePath = `${presetThemeRootPath}/${themeDir.theme}${SUB_SCREEN_DIR}`;
      if (FileUtil.isFileExists(subThemePath)) {
        this.presetThemeIdPathMap.set(themeDir.theme_id, subThemePath);
        this.presetThemeIdOriginMap.set(themeDir.theme_id, themeDir.origin);
        if (themeDir.origin !== ORIGIN_TYPE_PRESET) {
          TsLog.info(TAG, `SubTheme ${themeDir.theme_id} is not preset type, continue.`)
          continue;
        }
        if (isSuite) {
          this.presetSuiteThemes.push(themeDir.theme_id);
        } else {
          this.presetSubScreenThemes.push(themeDir.theme_id);
        }
      }
    }
  }

  /**
   * 获取用户的所有主题列表
   * @returns 应用过的所有主题列表
   */
  async getSubThemeUsed(): Promise<SubScreenInfo[]> {
    TsLog.info(TAG, 'begin to get used sub themes');
    await this.init();
    if (this.needUpdateSuiteEditorId) {
      let themeList: NullableType<ThemeInfo[]> = await TServiceApi.themeInfoInner().getCurrentInnerThemeInfoList(0);
      if (themeList) {
        await this.updateSuiteMap(themeList);
      }
    }
    return this.userSubScreenThemeList.convertToArray();
  }

  /**
   * 外屏主题画廊初始化
   * @returns void
   */
  async init(): Promise<void> {
    if (this.serviceHasInit) {
      TsLog.info(TAG, 'no need to init cache, return');
      return;
    }
    let cache: TsSubScreenCache = TsSubScreenCache.getInstance();
    let cachedSubThemeInfoList: NullableType<List<SubScreenInfo>> = await cache?.get();
    TsLog.info(TAG, `cache size is ${cachedSubThemeInfoList?.length ?? 0}`)
    await this.parseAllManifests();
    this.presetThemeIdOriginMap.set(CUSTOM_WALLPAPER_ID, ORIGIN_TYPE_PRESET);
    let screenInfoList: List<SubScreenInfo> = new List<SubScreenInfo>();
    if (cache.getIsFirstInit()) {
      this.needUpdateSuiteEditorId = true;
      if (cachedSubThemeInfoList && cachedSubThemeInfoList.length > 0) {
        let defaultTheme: SubScreenInfo = cachedSubThemeInfoList[0];
        this.defaultThemeId = defaultTheme.originId;
        screenInfoList.add(defaultTheme);
      }
      this.addPresetThemes(screenInfoList, this.presetSubScreenThemes, false);
      this.presetSuiteThemes.splice(this.presetSuiteThemes.indexOf(this.defaultThemeId), 1);
      this.addPresetThemes(screenInfoList, this.presetSuiteThemes, true);
      cache.setIsFirstInit(false);
    } else {
      cachedSubThemeInfoList?.forEach((item: SubScreenInfo, index: number) => {
        item.path =
          this.presetThemeIdPathMap.has(item.originId) ? (this.presetThemeIdPathMap.get(item.originId) ?? '') :
          item.path;
        if (item.customPath.startsWith(COVER_DIR)) {
          item.customPath = item.customPath.replace(COVER_DIR, `${THEME_ROOT_DIR}/t_pkg_sub_screen`);
        }
        if (item.path.startsWith(COVER_DIR)) {
          item.path = item.path.replace(COVER_DIR, `${THEME_ROOT_DIR}/t_pkg_sub_screen`);
        }
        if (item.isSuite && item.suiteEditorId === '') {
          this.needUpdateSuiteEditorId = true;
        }
        screenInfoList.add(item);
        if (item.isEnabled) {
          this.lastEnableTheme = index;
        }
      });
      this.cachedSubThemeInfoList = cachedSubThemeInfoList;
      // 仅hap改造上线后，用户首次升级场景进行主题包迁移
      SubThemeHelper.moveThemePkg(cachedSubThemeInfoList);
    }
    while (screenInfoList.length > MAX_GALLERY_COUNT) {
      if (this.lastEnableTheme === 0) {
        screenInfoList.removeByIndex(1);
      } else {
        screenInfoList.removeByIndex(0);
        this.lastEnableTheme -= 1;
      }
    }
    this.userSubScreenThemeList = screenInfoList;
    TsLog.info(TAG, `user theme size:${this.userSubScreenThemeList.length}, lastEnableTheme:${this.lastEnableTheme}`);
    this.serviceHasInit = true;
    await this.subScreenUpdate();
  }

  async addPresetThemes(screenInfoList: List<SubScreenInfo>, presetThemeIds: string[],
    isSuite: boolean): Promise<void> {
    TsLog.info(TAG, 'begin to add preset sub themes');
    for (let presetThemeId of presetThemeIds) {
      let editorId = screenInfoList.length;
      let subThemePath: string = this.presetThemeIdPathMap.get(presetThemeId) ?? '';
      const targetDir: string = `${SUM_THEME_PATH}${editorId}`;
      TsLog.info(TAG, `parseSubScreen targetDir: ${targetDir}`);
      FileUtil.copyDirAsync(`${subThemePath}`, `${targetDir}`).then((copyRet) => {
        if (!copyRet) {
          TsLog.warning(TAG, `copy fail src: ${subThemePath}`);
        } else {
          SubThemeUtil.checkThemePackage(editorId.toString(), targetDir + SUB_SCREEN_DIR)
        }
      });
      let subScreenInfo: SubScreenInfo =
        new SubScreenInfo(presetThemeId, editorId.toString(), subThemePath, targetDir + SUB_SCREEN_DIR);
      subScreenInfo.isSuite = isSuite;
      if (STICKER_ORIGIN_ID_LIST.includes(presetThemeId)) {
        subScreenInfo.order = STICKER_ORIGIN_ID_LIST.indexOf(presetThemeId);
      }
      screenInfoList.add(subScreenInfo);
    }
  }

  async updateSuiteMap(themeInfos: ThemeInfo[]) {
    if (!this.needUpdateSuiteEditorId) {
      return;
    }
    TsLog.info(TAG, 'begin to update suite editorIds');
    let idMap: Map<string, string> = new Map();
    themeInfos.forEach((themeInfo) => {
      idMap.set(themeInfo.id, themeInfo.editorId);
    })
    this.userSubScreenThemeList.forEach((subScreenTheme) => {
      if (subScreenTheme.isSuite) {
        subScreenTheme.suiteEditorId = idMap.get(subScreenTheme.originId) ?? '';
        this.editorIdMap.set(subScreenTheme.suiteEditorId, subScreenTheme.themeId);
      }
    })
    await this.subScreenUpdate();
    this.needUpdateSuiteEditorId = false;
    TsLog.info(TAG, JsonUtils.stringify(this.editorIdMap) ?? 'No json stringify');
  }

  public async onAllPresetsTheme(themeInfo: ThemeInfo[]): Promise<void> {
    TsLog.info(TAG, `onAllPresetsTheme start`);
    let cache: TsSubScreenCache = TsSubScreenCache.getInstance();
    if (cache.getIsFirstInit()) {
      TsLog.info(TAG, `first init scene`);
      try {
        cache.setIsFirstInit(false);
        let initInnerTheme: NullableType<ThemeInfo> = await TServiceApi.themeInfoInner().getCurrentInnerTheme();
        let initEditorId: string = initInnerTheme?.editorId ?? '0000000000000';
        this.editorIdMap.set(initEditorId, '0000000000000');
        TsLog.info(TAG, `onAllPresetsTheme initEditorId: ${initEditorId}`);
        this.userSubScreenThemeList.get(0).suiteEditorId = initInnerTheme?.editorId ?? '0000000000000';
        let subThemePackList = await this.parseAllSubScreen(initInnerTheme, themeInfo);
        subThemePackList?.forEach((item: SubScreenInfo) => {
          this.userSubScreenThemeList.add(item);
        })
        this.subScreenUpdate();
      } catch (e) {
        TsLog.error(TAG, `first init failed: ${e}`);
      }
    } else {
      TsLog.info(TAG, `restart scene`);
      for (let item of this.userSubScreenThemeList) {
        if (!item.suiteEditorId || item.suiteEditorId === '') {
          continue;
        }
        this.editorIdMap.set(item.suiteEditorId, item.themeId);
      }
    }
  }

  public registerListener(): void {
    EventEmitter.on(EventId.EVENT_ACTIVATE_THEME, (event: ActivateEventData) => this.onAllThemeActivated(event));
    EventEmitter.on(EventId.EVENT_GET_THEME_LIST, (event: ThemeInfo[]): Promise<void> => this.updateSuiteMap(event));
    EventEmitter.on(EventId.EVENT_SAVE_THEME, (event: ActivateEventData) => this.onAllThemeSaved(event));
    this.registerSecondMountedEvent();
    TsLog.info(TAG, 'register activate listener success');
  }

  private registerSecondMountedEvent() {
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [
        'usual.event.SECOND_MOUNTED'// 监听目录挂载完成
      ]
    };
    commonEventManager.createSubscriber(subscribeInfo).then((mSubscriber) => {
      TsLog.info(TAG, `registerSecondMountedEvent, createSubscriber res: ${!!mSubscriber}`);
      if (mSubscriber) {
        this.secondMountSubscriber = mSubscriber;
        commonEventManager.subscribe(this.secondMountSubscriber,() =>  {
          TsLog.info(TAG, 'secondMountedEvent callback');
          SubThemeHelper.moveThemePkg(this.cachedSubThemeInfoList);
          this.unregisterSecondMountedEvent();
        })
      }
    })
  }

  private unregisterSecondMountedEvent() {
    if (this.secondMountSubscriber) {
      commonEventManager.unsubscribe(this.secondMountSubscriber);
      this.secondMountSubscriber = undefined;
    }
  }

  /**
   * 需要唤起外屏拷贝对应主题资源的回调
   *
   * @param eventInfo 主题信息
   * @return
   */
  public async onAllThemeSaved(eventInfo: ActivateEventData): Promise<void> {
    TsLog.info(TAG, `onAllThemeSaved enter, themeId: ${eventInfo.id}, editorId = ${eventInfo.editorId}`);
    let isNeedActivate: boolean = false;
    await this.refreshThemeResource(eventInfo, isNeedActivate);
  }

  /**
   * 需要唤起外屏应用对应主题的回调
   *
   * @param eventInfo 主题信息
   * @return
   */
  public async onAllThemeActivated(eventInfo: ActivateEventData): Promise<void> {
    TsLog.info(TAG, `onAllThemeActivated enter, themeId: ${eventInfo.id}, editorId = ${eventInfo.editorId}`);
    let isNeedActivate: boolean = true;
    await this.refreshThemeResource(eventInfo, isNeedActivate);
  }

  /**
   * 刷新相关主题资源
   *
   * @param eventInfo 主题信息
   * @param isNeedActivate 是否需要激活主题
   * @return
   */
  private async refreshThemeResource(eventInfo: ActivateEventData, isNeedActivate: boolean = false): Promise<void> {
    let tPackagePath: string | undefined = eventInfo.path;
    if (!tPackagePath || !FileUtil.isFileExists(tPackagePath)) {
      TsLog.error(TAG, `tPackagePath not exist.`);
      return;
    }
    let subThemeSrc: string = `${tPackagePath}${'/'}${Constants.SUB_SCREEN_PREFIX}`;
    let subThemeCustomSrc: string | undefined = `${eventInfo.customPath}${'/'}${Constants.SUB_SCREEN_PREFIX}`;
    let themeEditorId: string = eventInfo.editorId;
    TsLog.info(TAG, `get theme src = ${subThemeSrc}, custom src = ${subThemeCustomSrc}, ` +
      `editor id = ${themeEditorId}, fullActivate: ${eventInfo.fullActivate} apply: ${eventInfo.apply}`);
    if (!FileUtil.isFileExists(subThemeSrc)) {
      TsLog.error(TAG, `subThemeSrc not exist.`);
      return;
    }
    if ((!(eventInfo.fullActivate || eventInfo.apply) || !eventInfo.sub_screen) && isNeedActivate) {
      TsLog.info(TAG, 'not suite theme scene, ignore.');
      return;
    }
    let deleteIdx: number = -1;
    let deleteThemeId: string = '';
    let shouldAdd: boolean = true;
    let currentEnableIndex: number = -1;
    let existCusthomSrc: boolean = FileUtil.isFileExists(subThemeCustomSrc);
    try {
      let themeOriginId: string = eventInfo.id;
      let subThemeEditorId: string = this.getThemeId(themeEditorId) ?? systemDateTime.getTime(false).toString();
      TsLog.info(TAG, `get sub theme editor id: ${subThemeEditorId}`);
      let targetDir: string = `${SUM_THEME_PATH}${subThemeEditorId}`;
      for (let index = 0; index < this.userSubScreenThemeList.length; index++) {
        let theme: SubScreenInfo = this.userSubScreenThemeList.get(index);
        if (theme.themeId === subThemeEditorId ||
            (themeOriginId === theme.originId && !FileUtil.isFileExists(eventInfo.customPath) &&
              !theme.isCustom && themeOriginId !== PANDORA_ORIGIN_ID)) {
          shouldAdd = false;
          currentEnableIndex = index;
          theme.isCustom = existCusthomSrc ? existCusthomSrc : theme.isCustom;
          subThemeEditorId = theme.themeId;
          targetDir = `${SUM_THEME_PATH}${subThemeEditorId}`;
          this.userSubScreenThemeList.set(index, theme);
        }
      }
      TsLog.info(TAG, `subThemeEditorId = ${subThemeEditorId}`);

      // theme is not existing in outScreen path, no need to remove target dir
      if (FileUtil.isFileExists(targetDir)) {
        const trimRet: boolean = await FileUtil.trimDirAsync(`${targetDir}`);
        if (!trimRet) {
          TsLog.warning(TAG, `trim fail src: ${targetDir}`);
        }
      }

      const copyRet: boolean = await FileUtil.copyDirAsync(`${subThemeSrc}`, `${targetDir}`);
      if (!copyRet) {
        TsLog.warning(TAG, `copy fail src: ${subThemeSrc}`);
      }
      // if theme style is default, no need to copy custom path
      if (FileUtil.isFileExists(subThemeCustomSrc)) {
        const copyCustomRet: boolean = await FileUtil.copyDirAsync(`${subThemeCustomSrc}`, `${targetDir}`);
        if (!copyCustomRet) {
          TsLog.warning(TAG, `copy fail src: ${subThemeCustomSrc}`);
        }
      }
      if (!isNeedActivate) {
        return;
      }
      if (shouldAdd) {
        let subTheme: SubScreenInfo =
          new SubScreenInfo(themeOriginId, subThemeEditorId, subThemeSrc, targetDir + '/sub_screen');
        let personalize = await this.checkIsPersonalize(subTheme.path + FILE_SEPARATOR + DESCRIPTION);
        if (themeOriginId === PANDORA_ORIGIN_ID) {
          personalize = true;
        }
        if (!personalize) {
          deleteIdx = await this.findOldNotPersonalizeTheme(subTheme, subThemeEditorId);
        }
        this.editorIdMap.set(themeEditorId, subThemeEditorId);
        TsLog.info(TAG, `add map: (${themeEditorId}, ${subThemeEditorId})`);
        subTheme.type = TYPE_COMBINED;
        subTheme.origin = this.getSubThemeOrigin(subTheme);
        subTheme.isCustom = existCusthomSrc;
        if (personalize) {
          subTheme.order = this.getMinUnusedOrder(subTheme.originId);
        }
        subTheme.isSuite = true;
        subTheme.suiteEditorId = themeEditorId;
        if (deleteIdx !== -1) {
          deleteThemeId = this.userSubScreenThemeList.get(deleteIdx).themeId;
          this.userSubScreenThemeList.insert(subTheme, deleteIdx)
          currentEnableIndex = deleteIdx;
        } else {
          this.userSubScreenThemeList.add(subTheme);
          this.tryDeleteOldestTheme();
          currentEnableIndex = this.userSubScreenThemeList.length - 1
        }
        TsLog.info(TAG, `onAllThemeActivated lastEnableTheme: ${currentEnableIndex}`);
      }
      this.userSubScreenThemeList.forEach((theme: SubScreenInfo) => {
        theme.isEnabled = false;
      })
      if (deleteThemeId !== '') {
        this.deleteSubThemeByThemeId(deleteThemeId);
      }
      this.lastEnableTheme = currentEnableIndex;
      this.userSubScreenThemeList.get(this.lastEnableTheme).isEnabled = true;
      this.subScreenUpdate();
      SubThemeUtil.checkThemePackage(subThemeEditorId, targetDir + SUB_SCREEN_DIR);
    } catch (error) {
      TsLog.error(TAG, `onAllThemeActivated error: ${error?.message}`);
    }
  }

  private async findOldNotPersonalizeTheme(subTheme: SubScreenInfo, newThemeId: string): Promise<number> {
    for (let i = 0; i < this.userSubScreenThemeList.length; i++) {
      let item = this.userSubScreenThemeList.get(i);
      if (item.originId === subTheme.originId && item.themeId !== newThemeId) {
        TsLog.info(TAG, `find not personalize theme, originId: ${item.originId} themeId: ${item.themeId}`);
        return i;
      }
    }
    return -1;
  }

  private getThemeId(editorId: string): string | undefined {
    if (!editorId) {
      return undefined;
    }
    for (let theme of this.userSubScreenThemeList) {
      if (theme.suiteEditorId === editorId) {
        return theme.themeId;
      }
    }
    return this.editorIdMap.get(editorId);
  }

  /**
   * if exceed the max theme list capacity, should delete oldest theme
   */
  private tryDeleteOldestTheme(): boolean {
    if (this.userSubScreenThemeList.length <= MAX_GALLERY_COUNT) {
      return false;
    }
    let deleteTheme = this.userSubScreenThemeList.removeByIndex(0);
    TsLog.info(TAG, `currenet theme listSize: ${this.userSubScreenThemeList.length} exceed max capacity, ` +
      `delete oldest theme originId: ${deleteTheme.originId} themeId: ${deleteTheme.themeId}`);
    if (FileUtil.isFileExists(deleteTheme.customPath)) {
      FileUtil.rmdirAsync(deleteTheme.customPath);
    }
    return true;
  }

  public async onAllThemeDeleted(themeInfoList: ThemeInfo[]): Promise<void> {
    let themeInfo = themeInfoList[0];
    TsLog.info(TAG, `onAllThemeDeleted enter, themeId: ${themeInfo?.id}, editorId: ${themeInfo?.editorId}, ` +
      `subThemeList.len: ${this.userSubScreenThemeList.length}, enableThemeIndex: ${this.lastEnableTheme}`);
    if (themeInfo == null || themeInfo == undefined) {
      TsLog.error(TAG, 'onAllThemeDeleted failed, themeInfo is invalid');
      return;
    }
    let subThemeEditorId = this.getThemeId(themeInfo?.editorId);
    if (subThemeEditorId == undefined) {
      TsLog.error(TAG, 'onAllThemeDeleted failed, subThemeEditorId is not exist in editorIdMap');
      return;
    }
    let deletedThemeIndex = -1;
    this.userSubScreenThemeList.forEach(async (theme: SubScreenInfo, index: number) => {
      if (subThemeEditorId === theme.themeId) {
        deletedThemeIndex = index;
      }
    })
    if (deletedThemeIndex == -1) {
      TsLog.error(TAG, 'onAllThemeDeleted failed, theme does not exist in userSubScreenThemeList');
      return;
    }
    let deletedTheme = this.userSubScreenThemeList.get(deletedThemeIndex);
    if (!deletedTheme.isSuite) {
      TsLog.error(TAG, 'onAllThemeDeleted failed, deleted theme is not suite theme');
      return;
    }
    let personalize = await this.checkIsPersonalize(deletedTheme.path + FILE_SEPARATOR + DESCRIPTION);
    if (deletedTheme.originId === PANDORA_ORIGIN_ID) {
      personalize = true;
    }
    if (!personalize) {
      this.editorIdMap.delete(themeInfo?.editorId);
      TsLog.error(TAG, 'onAllThemeDeleted failed, deleted theme is not personalize theme');
      return;
    }
    TsLog.info(TAG, `onAllThemeDeleted deletedThemeIndex: ${deletedThemeIndex}, isEnabled: ${deletedTheme.isEnabled}`);
    // deletedTheme is not activated
    if (!deletedTheme.isEnabled) {
      this.editorIdMap.delete(themeInfo?.editorId);
      this.userSubScreenThemeList.remove(deletedTheme);
      if (deletedThemeIndex < this.lastEnableTheme) {
        this.lastEnableTheme = this.lastEnableTheme - 1;
      }
      if (FileUtil.isFileExists(deletedTheme.customPath)) {
        FileUtil.rmdirAsync(deletedTheme.customPath);
      }
      this.subScreenUpdate();
      TsLog.info(TAG, 'onAllThemeDeleted finish, delete theme successfully');
      return;
    }
    // deletedTheme is activated
    deletedTheme.isEnabled = false;
    this.editorIdMap.delete(themeInfo?.editorId);
    this.userSubScreenThemeList.remove(deletedTheme);
    if (FileUtil.isFileExists(deletedTheme.customPath)) {
      FileUtil.rmdirAsync(deletedTheme.customPath);
    }
    if (this.userSubScreenThemeList.length >= 1) {
      let newThemeIndex = deletedThemeIndex == this.userSubScreenThemeList.length ?
        this.userSubScreenThemeList.length - 1 : deletedThemeIndex;
      let activateResult = await this.activateAndUpdateStatus(newThemeIndex);
      if (activateResult) {
        TsLog.info(TAG, 'onAllThemeDeleted finish, activate other theme successfully');
        return;
      }
    }
    let defaultThemeIndex = await this.getDefaultThemeIndex();
    if (defaultThemeIndex != -1) {
      let activateResult = await this.activateAndUpdateStatus(defaultThemeIndex);
      if (activateResult) {
        TsLog.info(TAG, 'onAllThemeDeleted finish, activate default theme successfully');
        return;
      }
    }
    let addDefaultSubTheme = await this.addDefaultSubTheme();
    if (!addDefaultSubTheme) {
      TsLog.error(TAG, 'onAllThemeDeleted error, addDefaultSubTheme failed, activate new theme failed');
      return;
    }
    defaultThemeIndex = this.userSubScreenThemeList.length - 1;
    let activateResult = await this.activateAndUpdateStatus(defaultThemeIndex);
    if (activateResult) {
      TsLog.info(TAG, 'onAllThemeDeleted finish, add and activate default theme successfully');
      return;
    }
    TsLog.error(TAG, 'onAllThemeDeleted error, activate new theme failed');
    return;
  }

  private async activateAndUpdateStatus(themeIndex: number): Promise<boolean> {
    let activated = await this.activate(this.userSubScreenThemeList.get(themeIndex));
    if (activated) {
      this.lastEnableTheme = themeIndex;
      this.userSubScreenThemeList.get(this.lastEnableTheme).isEnabled = true;
      this.subScreenUpdate();
    }
    return activated;
  }

  private async addDefaultSubTheme(): Promise<boolean> {
    let defaultPath = await this.getDefaultPath();
    if (!FileUtil.isFileExists(defaultPath)) {
      return false;
    }
    let content: string = FileUtil.getStringByFile(defaultPath + Constants.FILE_SEPARATOR + DESCRIPTION);
    if (StringUtils.isEmpty(content)) {
      return false;
    }
    try {
      let json: object | undefined = JsonUtils.parse(content);
      if (json) {
        this.userSubScreenThemeList.add(this.parseDefaultTheme(json, defaultPath));
        TsLog.info(TAG, 'addDefaultSubTheme successfully');
        return true;
      }
      return false;
    } catch (error) {
      TsLog.error(TAG, `addDefaultSubTheme error, ${error?.message}`);
      return false;
    }
  }

  private async checkIsPersonalize(filePath: string): Promise<boolean> {
    if (!FileUtil.isFileExists(filePath)) {
      TsLog.info(TAG, `not exists return false`);
      return false;
    }
    let content: string = FileUtil.getStringByFile(filePath);
    if (StringUtils.isEmpty(content)) {
      TsLog.info(TAG, 'is empty return')
      return false;
    }
    try {
      let json: object | undefined = JsonUtils.parse(content);
      return json && json['personalize'];
    } catch (error) {
      TsLog.error(TAG, `check is personalize error, ${error?.message}`);
      return false;
    }
  }

  private parseDefaultTheme(json : object, defaultPath : string) : SubScreenInfo {
    let themeId: string = json[Constants.ID_PREFIX];
    let defaultSubTheme: SubScreenInfo =
      new SubScreenInfo(themeId, systemDateTime.getTime(false).toString(), defaultPath);
    defaultSubTheme.type = TYPE_COMBINED;
    defaultSubTheme.isEnabled = false;
    defaultSubTheme.isSuite = true;
    return defaultSubTheme;
  }

  private async getDefaultPath(): Promise<string> {
    let themeDir: string = '';
    try {
      themeDir = await configPolicy.getOneCfgFile(THEME_PKG_DIR);
    } catch (error) {
      TsLog.error(TAG, `getDefaultPath error, ${error?.message}`);
      return '';
    }
    let defaultPath: string = themeDir + Constants.FILE_SEPARATOR + Constants.DEFAULT_THEME_NAME +
    Constants.FILE_SEPARATOR + Constants.SUB_SCREEN_PREFIX;
    return defaultPath;
  }

  private async getDefaultThemeIndex(): Promise<number> {
    let defaultThemeIndex = -1;
    let defaultPath = await this.getDefaultPath();
    if (StringUtils.isEmpty(defaultPath)) {
      return defaultThemeIndex;
    }
    this.userSubScreenThemeList.forEach(async (theme: SubScreenInfo, index: number) => {
      if (StringUtils.equals(defaultPath, theme.path)) {
        defaultThemeIndex = index;
      }
    })
    TsLog.info(TAG, `getDefaultThemeIndex ${defaultThemeIndex == -1 ? 'failed' : 'successfully'}, ` +
      `defaultThemeIndex = ` + defaultThemeIndex);
    return defaultThemeIndex;
  }

  private async activate(subTheme: SubScreenInfo): Promise<boolean> {
    if (!subTheme.path.endsWith(SUB_SCREEN_DIR)) {
      TsLog.error(TAG, 'activate path is error.');
      return false;
    }
    let isCustom: boolean = (subTheme.customPath?.length ?? 0) > 0;
    if (isCustom && !subTheme.customPath?.endsWith(SUB_SCREEN_DIR)) {
      TsLog.error(TAG, 'custom activate path is error.');
      return false;
    }
    let option: ThemeOptions = new ThemeOptions().enableSubScreen();
    let themePath: string = isCustom ? this.getParentPath(subTheme.customPath) : this.getParentPath(subTheme.path);
    SubThemeUtil.checkThemePackage(subTheme.themeId, themePath + SUB_SCREEN_DIR);
    TsLog.info(TAG, 'start to activate sub screen theme by theme service');
    return TServiceApi.themeActivate().activateTheme(themePath, option, false);
  }

  private async subScreenUpdate() {
    TsSubScreenCache.getInstance().update(this.userSubScreenThemeList);
  }

  public getParentPath(path: string | undefined): string {
    if (!path) {
      return StringUtils.EMPTY;
    }
    let index: number = path.lastIndexOf(FILE_SEPARATOR);
    if (index >= 0) {
      return path.substring(0, index);
    }
    return path;
  }
}

interface ThemeCategory {
  /**
   * 分类的名称，例如：theme_category_01（此为key名，value值在i18n目录下对应语言的配置文件内）
   */
  category: string;

  /**
   * 类别下的主题目录数组
   */
  dir: ThemeDir[];
}

/**
 * 定义主题目录的类型
 */
interface ThemeDir {
  /**
   * 主题包资源目录名称，eg：default、default_01
   */
  theme: string;

  /**
   * 主题资源id
   */
  theme_id: string;

  /**
   * 主题预置类型
   */
  origin: string;
}

export const subThemeService: SubThemeService = new SubThemeServiceImpl();