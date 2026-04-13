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

import { systemDateTime } from '@kit.BasicServicesKit';
import type abilityCommon from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import { AigcConstant, VideoPersonalizeParam } from './AigcConstant';
import { AigcFileUtils } from './AigcFileUtils';
import { Log } from './IdlService/Log';
import { EditThemeArg } from './TSCaller/EditThemeArg';
import { TsRemoteCaller } from './TSCaller/TsRemoteCaller';

const TAG: string = '[AIGCService]AIGCThemeInfoAdapter';

/**
 * AIGC主题资源管理的工具类
 */
export class AIGCThemeInfoAdapter {
  /**
   * 使用原图准备主题资源到临时目录，该目录用于后续新建一套潘多拉主题。具体流程包括：
   * 1. 创建主题目录结构（aod/lock/home）；2. 复制原始图像到各模块资源目录；
   *
   * @param originImgPath - 原图文件路径。
   * @param customPath - 应用主题的自定义增量目录。
   * @returns {Promise<boolean>} 返回 Promise，若所有步骤执行成功返回 `true`，否则返回 `false`。
   */
  public static async prepareOriThemeRsc(originImgPath: string, customPath: string): Promise<boolean> {
    if (!fs.accessSync(originImgPath)) {
      Log.error(TAG, `Origin image does not exist.`);
      return false;
    }
    return await AIGCThemeInfoAdapter.prepareCustomDirStructure(customPath, ['aod', 'lock', 'home']) &&
      AIGCThemeInfoAdapter.prepareEditorResources(originImgPath, originImgPath, customPath);
  }

  /**
   * 使用生成的视频及相关资源准备主题资源。该方法整合目录结构创建、资源复制及引擎类型的修改操作，将生成的视频及相关资源作为主题资源打包到指定路径。
   * 1. 创建主题目录结构（aod/lock/home/personalize）；2. 复制生成的视频及相关资源到各模块资源目录。
   *
   * @param themeID - 主题ID。
   * @param customPath -  应用主题的自定义增量目录（最终生成的结构化主题文件路径）。
   */
  public static async prepareAIGCVideoThemeRsc(themeID: string, customPath: string): Promise<boolean> {
    if (!await AIGCThemeInfoAdapter.prepareCustomDirStructure(customPath, ['aod', 'lock', 'home', 'personalize'])) {
      Log.error(TAG, `prepareAIGCVideoThemeRsc ${themeID} failed in prepareCustomDirStructure`);
      return false;
    };
    const resDirList: string[] = AigcFileUtils.listDirSync(`${AigcConstant.CAROUSEL_DIR}/${themeID}`);
    if (resDirList.length === 0) {
      Log.error(TAG, `prepareAIGCVideoThemeRsc ${themeID} failed: no video exist.`);
      return false;
    }
    if (!AIGCThemeInfoAdapter.prepareEditorResources(`${resDirList[0]}/first_frame.jpg`,
      `${resDirList[0]}/last_frame.jpg`, customPath, `${resDirList[0]}/aod.jpg`) ||
      !AIGCThemeInfoAdapter.prepareEngineResources(resDirList, customPath)) {
      Log.error(TAG, `prepareAIGCVideoThemeRsc ${themeID} failed in prepareEditorResources or prepareEngineResources`);
      return false;
    }
    const videoPersonalizeParam: VideoPersonalizeParam = { videoCount: resDirList.length };
    // return FileUtil.createFileWithJsonObject(`${customPath}/personalize/params.json`, videoPersonalizeParam);
    return true
  }

  /**
   * 创建自定义主题目录结构。该函数会根据提供的自定义路径创建符合主题包规范的目录，并从预置主题路径中复制必要文件。
   *
   * @param customPath - 应用主题的自定义增量目录，用于存放自定义文件，e.g. 用户选择的原图。
   * @param presetThemePath - 预置主题的路径。
   */
  private static async prepareCustomDirStructure(customPath: string, qualifierList: string[]): Promise<boolean> {
    try {
      if (fs.accessSync(customPath)) {
        fs.rmdirSync(customPath);
      }
      qualifierList.forEach((qualifier: string) => {
        const qualifierCustomPath: string = `${customPath}/${qualifier}/base/resources`;
        fs.mkdirSync(qualifierCustomPath, true);
      })
      // if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      //   fs.mkdirSync(`${customPath}/aod/unfolded/resources`, true);
      // }
      return true;
    } catch (err) {
      Log.info(TAG, `PrepareCustomDirStructure error. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  private static prepareEditorResources(lockImgPath: string, homeImgPath: string, customPath: string,
    dimImgPath?: string): boolean {
    try {
      const aodImgPath: string = dimImgPath ?? lockImgPath;
      fs.copyFileSync(aodImgPath, `${customPath}/aod/base/resources/aod_wallpaper_0.jpg`);
      // if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      //   fs.copyFileSync(aodImgPath, `${customPath}/aod/unfolded/resources/aod_wallpaper_0.jpg`);
      // }
      fs.copyFileSync(lockImgPath, `${customPath}/lock/base/resources/unlock_wallpaper_0.jpg`);
      fs.copyFileSync(homeImgPath, `${customPath}/home/base/resources/home_wallpaper_0.jpg`);
      return true;
    } catch (err) {
      Log.error(TAG, `PrepareEditorResources failed. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  private static prepareEngineResources(resDirList: string[], customPath: string): boolean {
    for (let index: number = 0; index < resDirList.length; index++) {
      const resDir: string = resDirList[index];
      try {
        if (index === 0) { // 适配历史无法轮播的主题
          fs.copyFileSync(`${resDir}/first_frame.jpg`, `${customPath}/personalize/base/resources/first_frame.jpg`);
          fs.copyFileSync(`${resDir}/last_frame.jpg`, `${customPath}/personalize/base/resources/last_frame.jpg`);
          fs.copyFileSync(`${resDir}/video.mp4`, `${customPath}/personalize/base/resources/video.mp4`);
        } else {
          fs.copyFileSync(`${resDir}/first_frame.jpg`,
            `${customPath}/personalize/base/resources/first_frame${index}.jpg`);
          fs.copyFileSync(`${resDir}/last_frame.jpg`,
            `${customPath}/personalize/base/resources/last_frame${index}.jpg`);
          fs.copyFileSync(`${resDir}/video.mp4`, `${customPath}/personalize/base/resources/video${index}.mp4`);
        }
      } catch (error) {
        Log.error(TAG, `prepareEngineResources copy failed: ${error?.code}, ${error?.message}`);
        return false;
      }
    }
    return true;
  }

  /**
   * 激活潘多拉3.0视频主题
   */
  public static async activateVideoTheme(context: abilityCommon.ServiceExtensionContext,
    themeID: string): Promise<boolean> {
    const toActivateThemePath: string = `${AigcConstant.CAROUSEL_DIR}/temp_${systemDateTime.getTime()}`;
    try {
      let retCode: boolean = await AIGCThemeInfoAdapter.prepareAIGCVideoThemeRsc(themeID, toActivateThemePath);
      if (!retCode) {
        Log.error(TAG, `generateVideoCallback prepareAIGCVideoThemeRsc failed.`);
        return false;
      }
      let arg: EditThemeArg = new EditThemeArg(themeID, 'Pandora');
      arg.customPath = toActivateThemePath;
      arg.activate = false;
      arg.isUsable = true;
      retCode = await TsRemoteCaller.getInstance(context).editTheme(arg);
      Log.info(TAG, `generateVideoCallback edit theme success: ${retCode}`);
      return retCode;
    } catch (error) {
      Log.error(TAG, `activateVideoTheme failed. Code is ${error?.code}, message is ${error?.message}`);
      return false;
    } finally {
      try {
        fs.rmdirSync(toActivateThemePath);
      } catch (error){
        Log.error(TAG, `activateVideoTheme remove toActivateThemePath_${themeID} failed.`);
      }
    }
  }
}

export class Image {
  public src: string = '';
}

export class GalleryCardLockConfig {
  public type: string = '';
  public image: Image = new Image();
  public clockVisible: boolean = true;
}

export class HomeManifest {
  public type: string = '';
  public image: Image = new Image();
  public wallpaperTouchable: boolean = true;
  public applyFrom: string = '';
}