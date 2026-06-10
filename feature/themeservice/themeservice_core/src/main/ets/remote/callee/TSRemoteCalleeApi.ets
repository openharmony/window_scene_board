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
  ActivateType,
  EditThemeArg,
  FontInfo,
  OriginType,
  TConfigArg,
  ThemeInfo,
  ThemeOptions,
  ThemeRecommendInfo,
  ThemeResource,
  TrialContentType,
  TrialRollbackType,
  WallPaperInfo,
} from '@ohos/themeservice_inner_api/Index';
import { NullableType } from '@ohos/themeservicebase/Index';
import { GlobalPersistInfo } from '../model/GlobalPersistInfo';
import { OnlineThemeInfo } from '../model/OnlineThemeInfo';
import { TrialThemeInfo } from '../model/TrialThemeInfo';
import { UpdateResourceInfo } from '../../cache/UpdateThemeInfoCache';

export interface TSRemoteCalleeApi {
  /**
   * 大小画廊获取主题列表。调用方：合一编辑器（画廊）
   * @param type 获取主题列表入口类型 大画廊: 1 设置小画廊：0
   * @returns 主题列表信息
   */
  getThemeList(type: number): Promise<NullableType<ThemeInfo[]>>;

  /**
   * 获取当前主题。调用方：合一编辑器
   * @returns 当前主题信息
   */
  getCurrentTheme(): Promise<NullableType<ThemeInfo>>;

  /**
   * 应用编辑的主题。调用方：合一编辑器
   * @param editorId 画廊编辑ID
   * @param option 应用选项
   * @param innerScreenOnly 是否仅应用内屏
   * @returns 应用结果
   * @deprecated {Use the editTheme() method instead}
   */
  activateEditedTheme(editorId: string, option?: ThemeOptions, innerScreenOnly?: boolean): Promise<boolean>;

  /**
   * 恢复出厂.调用方：演示app
   * @returns
   */
  factoryReset(): Promise<void>;

  /**
   * 主题app通知在线推荐更新。调用方：主题app
   * @param recommendInfoList 更新数据
   * @returns 结果 0:成功，其他：失败
   */
  notifyOnlineRecommendationUpdate(recommendInfoList: ThemeRecommendInfo[]): Promise<number>;

  /**
   * 获取在线推荐信息；调用方：合一编辑器（画廊）
   * @returns 现在推荐信息
   */
  getOnlineRecommendation(): Promise<NullableType<ThemeRecommendInfo[]>>;

  /**
   * 删除主题接口；调用方：主题app
   * @param themeResources 删除主题资源列表
   * @returns 删除主题是否成功
   */
  deleteTheme(themeResources: ThemeResource[]): Promise<boolean>;

  /**
   * 移除主题接口；调用方：合一编辑器（画廊）
   * @param editorId 主题编辑id
   * @returns 删除主题是否成功
   */
  removeTheme(editorId: string): Promise<void>;

  /**
   * 设置壁纸；调用方：合一编辑器
   * @param wallPapers 壁纸信息，可以一次设置多种类型壁纸
   * @returns 结果
   */
  setWallPaper(wallPapers: WallPaperInfo[]): Promise<boolean>;

  /**
   * 应用主题；调用方：主题app
   * @param themeDir 主题资源包的根路径
   * @param option 应用主题参数
   * @param apply 是否应用到主题画廊
   * @param innerScreenOnly 是否仅应用内屏
   * @returns 应用结果
   */
  activateTheme(themeDir: string, option?: ThemeOptions, apply?: boolean, innerScreenOnly?: boolean): Promise<boolean>;

  /**
   * 应用自定义主题；调用方：合一编辑器
   * @param themeDir 主题资源包的根路径
   * @param customThemePkgPath 自定义主题资源包路径
   * @param option 应用主题参数
   * @param apply 是否应用保存到主题画廊
   * @param innerScreenOnly 是否仅应用内屏
   * @returns 应用结果
   */
  activateThemeCustom(themeDir: string, customThemePkgPath?: string, option?: ThemeOptions,
    apply?: boolean, innerScreenOnly?: boolean): Promise<boolean>;

  /**
   * 保存主题；调用方：合一编辑器
   * @param path 主题资源包的根路径
   * @param custom 自定义主题资源包路径
   * @param isUsable 主题包是否可用(部分主题存在可用和不可用两种状态)
   * @returns 主题editorId
   */
  saveThemeCustom(path: string, custom?: string, isUsable?: boolean): Promise<string>;

  /**
   * 上云托管主题下载成功；调用方：主题app
   * @param id 主题资源id
   * @param path 下载后的资源路径
   * @returns 结果 true：上云主题下载保存成功，false：上云主题下载成功处理失败
   */
  hostedThemeDownloaded(id: string, path: string): Promise<boolean>;

  /**
   * 应用字体；调用方：合一编辑器
   * @param id 字体包id
   * @param ttf 字体ttf文件路径
   * @param originType 字体包安装来源
   * @param ttfExt 字体ttf文件路径数组
   * @param multiWeight 是否可调节字重
   * @returns 应用结果
   */
  applyFont(id: string, ttf: string, originType: OriginType, ttfExt?: string[], multiWeight?: boolean): Promise<number>;

  /**
   * 激活试用主题；调用方：主题app
   * @param path - 主题路径
   * @param trialDuration - 试用持续时间 试用时长 ms ，限制[0, 15分钟]，（activateType = 1）[0,3月]
   * @param trialType - 试用类型 'theme' | 'font'
   * @param activateType - 使能类型 0 | undefined：试用 1：限免
   * @param reminderDuration - 限免提醒时间 提前通知的剩余时间(ms),限制[0,3月]
   * @return 结果 0：成功 其他：失败
   */
  activateTrialTheme(path: string, trialDuration: number, trialType: TrialContentType, activateType?: ActivateType,
    reminderDuration?: number): Promise<number>;

  /**
   * 提升试用主题；调用方：主题app
   * @param {string} id - 主题ID
   * @param {string} path - 主题路径
   * @param {trialType} trialType - 试用类型
   * @return {Promise<number>} 返回一个Promise，其解析值为数字
   */
  promoteTrialTheme(id: string, path: string, trialType: TrialContentType): Promise<number>;

  /**
   * 回滚主题到指定版本；调用方：主题app
   * @param rollbackType - 回滚类型，'prev'表示回滚到上一个版本，'default'表示回滚到默认版本
   * @return 回滚结果 0：成功 其他：失败
   */
  rollbackTheme(rollbackType: TrialRollbackType): Promise<number>;

  /**
   * 获取试用主题信息；调用方：主题app
   * @return 结果，存在试用则返回TrialThemeInfo，不存在则返回undefined
   */
  getTrialTheme(): Promise<Nullable<TrialThemeInfo>>;

  /**
   * 获取在线资源信息列表；调用方：主题app
   * @returns 在线主题信息列表
   */
  getOnlineThemeList(): Promise<Nullable<OnlineThemeInfo[]>>;

  /**
   * 更新在线资源；调用方：主题app
   * @param onlineThemeInfos 在线资源信息列表
   * @param vipExpirationDate 会员过期时间
   * @returns 结果 0：成功 其他：失败
   */
  updateOnlineTheme(onlineThemeInfos: OnlineThemeInfo[], vipExpirationDate: number): Promise<number>;

  /**
   * 应用主题皮肤；调用方：主题app
   * @param skinPkg 皮肤资源目录，可以支持多个皮肤包
   * @param pkgNames 需要换肤的应用bundle名称列表
   * @returns 结果
   */
  setSkin(skinPkg: String, pkgNames: string[]): Promise<boolean>;

  /**
   * 设置当前主题资源；调用方：桌面、合一编辑器
   * @param tConfigArgs 需要写入的参数列表
   * @param activated true:存入增量包&调用SA使能该数据；false:只存入增量包
   * @returns 结果
   */
  setCurrentThemeCfg(tConfigArgs: TConfigArg[], activated?: boolean): Promise<boolean>;

  /**
   * 修改主题属性值
   * @param id 和主题关联的id
   * @param property 主题属性
   * @param defaultValue 主题属性默认值
   * @returns 是否成功
   */
  modifyThemePropertyValue(id: string, property: string, defaultValue?: string): Promise<boolean>;

  /**
   * 获取主题属性值
   * @param id 和主题关联的id
   * @param property 主题属性
   * @returns 主题属性值
   */
  getThemePropertyValue(id: string, property: string): Promise<string>;

  /**
   * 删除主题属性值
   * @param id 和主题关联的id
   * @param property 主题属性
   * @returns 是否成功
   */
  removeThemePropertyValue(id: string, property?: string): Promise<boolean>;

  /**
   * 应用图标资源；调用方：设置-桌面和个性化-图标
   * @param iconResource 图标资源路径
   * @returns 应用是否成功
   */
  applyIcons(iconResource: string): Promise<boolean>;

  /**
   * 应用aod资源；调用方：设置-桌面和个性化-息屏显示
   * @param aodThemeDir aod主题目录
   * @returns 结果
   */
  applyAod(aodThemeDir: string): Promise<boolean>;

  /**
   * 校准限免主题信息；调用方：主题app
   * @param id 主题id
   * @param type 限免类型 'theme' | 'font'
   * @param limitedDuration 限时剩余时间时长(ms), 限制[0,3月]
   * @param reminderDuration 提前通知的剩余时间(ms),限制[0,3月]
   * @returns 结果 0：成功 其他：失败
   */
  correctLimitedFreeTheme(id: string, type: TrialContentType, limitedDuration: number,
    reminderDuration: number): Promise<number>;

  /**
   * 应用编辑的主题。调用方：合一编辑器、主题app
   * @param editorId 画廊编辑ID
   * @param customPath 主自定义主题资源路径，按照主题包规范存放
   * @param option 应用主题参数
   * @param activate true:激活（默认）；false:不激活，只应用到TS沙箱小包目录
   * @param from ‘default’：默认；‘gallery’：画廊；‘Personalize’：个性化编辑
   * @param innerScreenOnly 是否仅应用内屏
   * @returns 应用结果
   */
  editTheme(editArg: EditThemeArg, innerScreenOnly?: boolean): Promise<boolean>;

  /**
   * 获取当前正在使用的字体信息
   *
   * @returns 当前字体信息
   */
  getCurrentFont(): Promise<NullableType<FontInfo>>;

  /**
   * 切换当前主题风格，调用方：在线引擎
   * @param contentType 需要切换的资源，目前只有‘aod’ ‘skin’
   * @param style 切换到的风格名
   * @returns 是否切换成功
   */
  activateThemeStyle(contentType: string[], style: string): Promise<boolean>;

  /**
   * 设置持久化数据，与ID强关联
   * @param themeId 主题id
   * @param version 版本
   * @param data 数据
   * @returns 是否设置成功
   */
  setGlobalPersist(globalPersistInfo: GlobalPersistInfo): Promise<boolean>;

  /**
   * 获取主题持久化数据
   * @returns Nullable<GlobalPersistInfo>
   */
  getGlobalPersist(): Promise<Nullable<GlobalPersistInfo>>;

  /**
   * 获取需要提示更新的主题列表，调用方：合一编辑
   *
   * @returns 需要提示更新的主题列表
   */
  getUpdateThemeList(): Promise<NullableType<UpdateResourceInfo[]>>;

  /**
   * 标记当前主题不提示更新，调用方：合一编辑
   *
   * @param id 主题id
   * @param ignoreVersion 当前忽略更新的版本
   * @returns 是否标记成功
   */
  ignoreUpdateTheme(id: string, ignoreVersion: string): Promise<boolean>;

  /**
   * 清除主题更新的所有缓存,调用方：主题app
   *
   * @returns
   */
  clearUpdateThemeAllCache(): Promise<boolean>;
}