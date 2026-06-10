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
import { SCBSceneInfo } from '../session/SCBSceneInfo';
import { SplitRatioEnum } from '../session/SCBSplitParam';
import { SCBSceneContainerSession } from '../session/SCBSceneContainerSession';
import { SCBTriFoldManager, DeviceHelper } from '@ohos/frameworkwrapper';
import display from '@ohos.display';
import screenSessionManager from '@ohos.screenSessionManager';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';

type FixedSplitRatioInfo = [string, number[]];

export class SCBSplitUtils {
  public static FIXED_SPLIT_RATIO_INFOS: FixedSplitRatioInfo [] = [
    ['com.ohos.camera', [SplitRatioEnum.ONE_TO_TWO]],
  ];

  /**
   * 是否超大屏固定分屏比例场景
   *
   * @param sceneInfo SCBSceneInfo
   * @returns { boolean }
   */
  public static isUltraScreenFixedSplitRatioScene(sceneInfo: SCBSceneInfo | null | undefined): boolean {
    if (!DeviceHelper.isUltraScreenProduct()) {
      return false;
    }
    if (SCBSplitUtils.getFixedSplitRatio(sceneInfo) === SplitRatioEnum.UNDEFINED) {
      return false;
    }
    if (SCBSplitUtils.isSupportFixedSplitRatioForTriFold()) {
      return false;
    }
    return true;
  }

  /** 是否为定制分屏比例的应用
   *
   * @param sceneInfo
   * @returns
   */
  public static isFixedSplitRatioScene(sceneInfo: SCBSceneInfo | null | undefined): boolean {
    return SCBSplitUtils.getFixedSplitRatio(sceneInfo) !== SplitRatioEnum.UNDEFINED;
  }

  /** 读取定制的分屏比例
   *
   * @param sceneInfo
   * @returns
   */
  public static getFixedSplitRatio(sceneInfo: SCBSceneInfo | null | undefined): SplitRatioEnum {
    if (!sceneInfo) {
      return SplitRatioEnum.UNDEFINED;
    }
    let index = SCBSplitUtils.FIXED_SPLIT_RATIO_INFOS.findIndex(
      (value: FixedSplitRatioInfo) => (value[0] === sceneInfo.bundleName));
    return index === -1 ? SplitRatioEnum.UNDEFINED : SCBSplitUtils.FIXED_SPLIT_RATIO_INFOS[index][1][0];
  }

  public static getFixedSplitRatioSceneInfoInSplit(container: SCBSceneContainerSession | null | undefined):
    SCBSceneInfo | null | undefined {
    if (!container) {
      return null;
    }
    let fixedRatioSceneInfo: SCBSceneInfo | null | undefined = null;
    if (SCBSplitUtils.isFixedSplitRatioScene(container.primarySession?.sceneInfo)) {
      fixedRatioSceneInfo = container.primarySession?.sceneInfo;
    } else if (SCBSplitUtils.isFixedSplitRatioScene(container.secondarySession?.sceneInfo)) {
      fixedRatioSceneInfo = container.secondarySession?.sceneInfo;
    }
    return fixedRatioSceneInfo;
  }

  /** 是否包含固定分屏比例的应用
   *
   * @returns
   */
  public static hasFixedSplitRatioScene(container: SCBSceneContainerSession | null | undefined): boolean {
    if (!container) {
      return false;
    }
    return SCBSplitUtils.isFixedSplitRatioScene(container.primarySession?.sceneInfo) ||
    SCBSplitUtils.isFixedSplitRatioScene(container.secondarySession?.sceneInfo);
  }

  public static isSupportFixedSplitRatioForTriFold(): boolean {
    if (SCBTriFoldManager.getInstance().isCurGState() && DeviceHelper.isLandscape()) {
      return true;
    }
    let foldStatus: display.FoldStatus = SCBScreenSessionManager.getInstance().getCurFoldStatus();
    if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      // 相机后当前场景
      if (SCBTriFoldManager.getInstance().isCurFState()) {
        return false;
      }
      // 双屏同显场景
      return true;
    }
    return SCBTriFoldManager.getInstance().isCurMState();
  }

  public static isPrimarySessionFixedSplitRatio(containerSession: SCBSceneContainerSession): boolean {
    return SCBSplitUtils.isFixedSplitRatioScene(containerSession.primarySession?.sceneInfo);
  }

  public static getSceneInfoQueryKey(sceneInfo: SCBSceneInfo): string {
    return sceneInfo.bundleName + sceneInfo.moduleName + sceneInfo.abilityName;
  }
}