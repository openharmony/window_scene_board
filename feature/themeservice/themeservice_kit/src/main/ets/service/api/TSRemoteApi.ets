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
import { TConfigArg } from '../model/TConfigArg';
import { WallPaperInfo } from '../model/WallPaper';

/**
 * 通用API（大桌面可直接调用）
 */
export interface TSRemoteApi {
  /**
   * 设置当前主题资源
   * @param tConfigArgs 需要写入的参数列表
   * @param apply true:存入增量包&调用SA使能该数据；false:只存入增量包
   * @returns 结果
   */
  setCurrentThemeCfg(tConfigArgs: TConfigArg[], activated?: boolean): Promise<boolean>;

  /**
   * 应用图标资源
   * @param iconResource 图标资源路径
   * @returns 应用是否成功
   */
  applyIcons(iconResource: string): Promise<boolean>;

  /**
   * 应用aod资源
   * @param aodThemeDir aod主题目录
   * @returns 结果
   */
  applyAod(aodThemeDir: string): Promise<boolean>;

  /**
   * 应用壁纸资源
   * @param wallPapers 壁纸信息
   * @returns 结果
   */
  applyWallpaper(wallPapers: WallPaperInfo[]): Promise<boolean>;
}