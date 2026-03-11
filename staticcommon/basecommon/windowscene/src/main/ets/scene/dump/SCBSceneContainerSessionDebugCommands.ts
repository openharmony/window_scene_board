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
import { KeyValueArray, SCBDebugUtils } from './uiDumpUtils/SCBDebugUtils';
import { SCBSceneContainerSession, SCBSceneContainerSessionArray } from '../session/SCBSceneContainerSession';
import { SCBSceneSessionDebugCommands } from './SCBSceneSessionDebugCommans';

export class SCBSceneContainerSessionDebugCommands {
  public static dealContainerSessionList(containerSessionList: SCBSceneContainerSessionArray, args: string[]): string {
    if (args.length === 0) {
      return 'Available modules:-n -all -i';
    }
    switch (args[0]) {
      case '-n':
        return SCBSceneContainerSessionDebugCommands.buildNames(containerSessionList);
      case '-all':
        return SCBSceneContainerSessionDebugCommands.buildContainerAllList(containerSessionList);
      case '-i':
        return SCBSceneContainerSessionDebugCommands.buildContainerInfoList(containerSessionList);
      default:
        return 'Available modules:-n -all -i';
    }
  }

  public static dealContainerSessionCommands(
    containerSessionList: SCBSceneContainerSessionArray, args: string[]): string {
    if (args.length === 0) {
      return 'Available modules:-id';
    }
    if (args[0] === '-id') {
      if (args.length === 1) {
        let ids = '';
        containerSessionList.forEach((container) => {
          ids += container.containerId + ' ';
        });
        return ids;
      }
      let containerId = Number.parseInt(args[1]);
      let container: SCBSceneContainerSession | null = containerSessionList.findByContainerId(containerId);
      if (container == null) {
        return 'Can not find container,Please check containerId';
      }
      switch (args[2]) {
        case '-i':
          return SCBSceneContainerSessionDebugCommands.buildContainerInfo(container);
        case '-all':
          return SCBSceneContainerSessionDebugCommands.buildContainerAll(container);
        case '-pri':
          return SCBSceneSessionDebugCommands.buildListSession(container.getPrimarySessionList());
        case '-sec':
          return SCBSceneSessionDebugCommands.buildListSession(container.getSecondarySessionList());
        default:
          return 'Available modules:-i -all -pri -sec';
      }
    }
    return 'Available modules:-id';
  }

  static buildNames(containerSessionList: SCBSceneContainerSessionArray): string {
    let names = '';
    containerSessionList.forEach((container) => {
      names += container.getName() + '\r\n';
    });
    return names;
  }

  public static buildContainerInfo(container: SCBSceneContainerSession): string {
    return SCBDebugUtils.buildContext(SCBSceneContainerSessionDebugCommands.buildContainerInfoContext(container));
  }

  public static buildContainerInfoList(containerSessionList: SCBSceneContainerSessionArray): string {
    let arr: KeyValueArray[] = [];
    containerSessionList.forEach((container) => {
      let keyValues: KeyValueArray = SCBSceneContainerSessionDebugCommands.buildContainerInfoContext(container);
      arr.push(keyValues);
    });
    return SCBDebugUtils.buildArrayContext(arr);
  }

  public static buildContainerAll(container: SCBSceneContainerSession): string {
    let containerInfoArray: KeyValueArray = SCBSceneContainerSessionDebugCommands.buildContainerAllArray(container);
    return SCBDebugUtils.buildContext(containerInfoArray);
  }

  public static buildContainerAllList(containerSessionList: SCBSceneContainerSessionArray): string {
    let arr: KeyValueArray[] = [];
    containerSessionList.forEach((container) => {
      arr.push(SCBSceneContainerSessionDebugCommands.buildContainerAllArray(container));
    });
    return SCBDebugUtils.buildArrayContext(arr);
  }

  private static buildContainerInfoContext(container: SCBSceneContainerSession): KeyValueArray {
    let containerInfo: KeyValueArray = new KeyValueArray();
    containerInfo.push('containerId', container.containerId);
    containerInfo.push('name', container.getName());
    if (container.primarySession) {
      containerInfo.push('primaryId', container.primarySession.sceneInfo.persistentId);
      containerInfo.push('primarySession', container.primarySession);
    }
    if (container.secondarySession) {
      containerInfo.push('secondaryId', container.secondarySession.sceneInfo.persistentId);
      containerInfo.push('secondarySession', container.primarySession);
    }
    containerInfo.push('height', container.height.getVp());
    containerInfo.push('width', container.width.getVp());
    containerInfo.push('clipHeight', container.needRenderClip.clipHeight.getVp());
    containerInfo.push('clipWidth', container.needRenderClip.clipWidth.getVp());
    containerInfo.push('currentRotation', container.currentRotation);
    containerInfo.push('isFloat', container.isFloat);
    containerInfo.push('isSplit', container.isSplit);
    containerInfo.push('isDisappearing', container.isDisappearing);
    containerInfo.push('needRenderPos', container.needRenderPos);
    containerInfo.push('needRenderAlpha', container.needRenderAlpha);
    containerInfo.push('needRenderShowInRecent', container.needRenderShowInRecent);
    containerInfo.push('needRenderVisibility', container.needRenderVisibility);
    containerInfo.push('needRenderScale', container.needRenderScale);
    containerInfo.push('needRenderRotate', container.needRenderRotate);
    containerInfo.push('needRenderZIndex', container.needRenderZIndex);
    containerInfo.push('needRenderBackgroundAlpha', container.needRenderBackgroundAlpha);
    containerInfo.push('needRenderShowRecentTitle', container.needRenderShowRecentTitle);
    containerInfo.push('needRenderRecentTitleWidth', container.needRenderRecentTitleWidth);
    containerInfo.push('needRenderTitleViewAlpha', container.needRenderRecentTitleWidth);
    containerInfo.push('needRenderTranslate', container.needRenderTranslate);
    containerInfo.push('needRenderRecentDeleteScale', container.needRenderRecentDeleteScale);
    containerInfo.push('needRenderRecentDeleteTranslate', container.needRenderRecentDeleteTranslate);
    containerInfo.push('needRenderRecentCoverScale', container.needRenderRecentCoverScale);
    containerInfo.push('needRenderRecentCoverTranslate', container.needRenderRecentCoverTranslate);
    containerInfo.push('needRenderRecentTitleTranslate', container.needRenderRecentTitleTranslate);
    containerInfo.push('needRenderBorderRadius', container.needRenderBorderRadius);
    containerInfo.push('needPreBuild', container.needPreBuild);
    return containerInfo;
  }


  private static buildContainerAllArray(container: SCBSceneContainerSession): KeyValueArray {
    let containerAll: KeyValueArray = SCBSceneContainerSessionDebugCommands.buildContainerInfoContext(container);
    containerAll.push('containerId', container.containerId);
    containerAll.push('rotateX', container.needRenderRotate.rotateX);
    containerAll.push('centerX', container.needRenderRotate.centerX);
    containerAll.push('centerY', container.needRenderRotate.centerY);
    containerAll.push('rotateAngle', container.needRenderRotate.angle);
    containerAll.push('iconAlpha', container.iconAlpha);
    containerAll.push('badgeAlpha', container.badgeAlpha);
    containerAll.push('badgeVisibility', container.badgeVisibility);
    containerAll.push('cardScale', container.cardScale);
    containerAll.push('hoverState', container.needRenderRecentHoverState.hoverState);
    containerAll.push('isNotSupportSplit', container.isNotSupportSplit);
    containerAll.push('companionIconInfo', container.companionIconInfo);
    return containerAll;
  }
}