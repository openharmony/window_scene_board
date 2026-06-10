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
import { singleManager } from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { gravityAnimationManager } from '../../manager/GravityAnimationManager';
import { GravityAnimationConfig } from '../config/GravityAnimationConfig';

/**
 * 引力动效维测类
 *
 * @since 2024/04/20
 */
export class GravityAnimationDebug {
  private static isRegistered = false;
  private static commonSetNumberValue(args: Array<string>, callback: (value: number) => void): boolean {
    if (args.length === 0) {
      return false;
    }

    let value = Number(args[0]);
    if (isNaN(value)) {
      return false;
    }

    callback(value);
    return true;
  }

  private static commonSetStringValue(args: Array<string>, callback: (value: string) => void): boolean {
    if (!args || args.length === 0) {
      return false;
    }

    callback(args[0]);
    return true;
  }

  private static getResult(res: boolean): string {
    return res ? 'success' : 'failed';
  }

  public static getCommands(): DebugCommand[] {
    let cmds: DebugCommand[] = [];

    cmds.push({
      cmdName: 'SetEnable',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setEnable);
        return 'Set Enable as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetMaxRadius',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setMaxRadius);
        return 'Set MaxRadius as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetMaxRadiusFactor',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setMaxRadiusFactor);
        return 'Set MaxRadiusFactor as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetMinRadius',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setMinRadius);
        return 'Set MinRadius as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetWaveSpeed',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setWaveSpeed);
        return 'Set WaveSpeed as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetWaveRangeConstant',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setWaveRangeConstant);
        return 'Set WaveRangeConstant as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetWaveDuration',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setWaveDuration);
        return 'Set WaveDuration as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetCurve',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetStringValue(args, GravityAnimationConfig.setCurve);
        return 'Set Curve as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetCurveParam1',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setCurveParam1);
        return 'Set Curve-Parameter-1 as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetCurveParam2',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setCurveParam1);
        return 'Set Curve-Parameter-2 as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetCurveParam3',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setCurveParam1);
        return 'Set Curve-Parameter-3 as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetCurveParam4',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setCurveParam1);
        return 'Set Curve-Parameter-4 as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetDelayOnDrop',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setDelayOnDrop);
        return 'Set Delay-On-Drop as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetDelayOnFolderChangeToBig',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setDelayOnFolderChangeToBig);
        return 'Set Delay-On-Folder-Change-To-Big as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetDelayOnFolderChangeToSmall',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args,
          GravityAnimationConfig.setDelayOnFolderChangeToSmall);
        return 'Set Delay-On-Folder-Change-To-Small as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetDelayOnRemoveApplication',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setDelayOnRemoveApplication);
        return 'Set Delay-On-Remove-Application as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetDelayOnRemoveCard',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setDelayOnRemoveCard);
        return 'Set Delay-On-Remove-Card as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetDelayOnAddCard',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setDelayOnAddCard);
        return 'Set Delay-On-Remove-Card as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetDelayOnMergeAsFolder',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setDelayOnMergeAsFolder);
        return 'Set Delay-On-Merge-as-folder as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'SetDelayOnAddToFolder',
      callback: (args: Array<string>) => {
        let res = GravityAnimationDebug.commonSetNumberValue(args, GravityAnimationConfig.setDelayOnAddToFolder);
        return 'Set Delay-On-Add-to-Folder as ' + args[0] + ' ' + GravityAnimationDebug.getResult(res);
      }
    }, {
      cmdName: 'Show',
      callback: (args: Array<string>) => {
        let res = 'show gravity config below: \n';
        res += 'Enable                    : ' + GravityAnimationConfig.isEnable() + ' \n';
        res += 'MaxRadius                 : ' + GravityAnimationConfig.getMaxRadius() + ' \n';
        res += 'MaxRadiusFactor           : ' + GravityAnimationConfig.getMaxRadiusFactor() + ' \n';
        res += 'MinRadius                 : ' + GravityAnimationConfig.getMinRadius() + ' \n';
        res += 'WaveSpeed                 : ' + GravityAnimationConfig.getWaveSpeed() + ' \n';
        res += 'WaveRangeConstant         : ' + GravityAnimationConfig.getWaveRangeConstant() + ' \n';
        res += 'WaveDuration              : ' + GravityAnimationConfig.getWaveDuration() + ' \n';
        res += 'Curve                     : ' + GravityAnimationConfig.getCurveDesc() + ' \n';
        res += 'DelayOnDrop               : ' + GravityAnimationConfig.getDelayOnDrop() + ' \n';
        res += 'DelayOnFolderChangeToBig  : ' + GravityAnimationConfig.getDelayOnFolderChangeToBig() + ' \n';
        res += 'DelayOnFolderChangeToSmall: ' + GravityAnimationConfig.getDelayOnFolderChangeToSmall() + ' \n';
        res += 'DelayOnRemoveApplication  : ' + GravityAnimationConfig.getDelayOnRemoveApplication() + ' \n';
        res += 'DelayOnRemoveCard         : ' + GravityAnimationConfig.getDelayOnRemoveCard() + ' \n';
        res += 'DelayOnAddCard            : ' + GravityAnimationConfig.getDelayOnAddCard() + ' \n';
        res += 'DelayOnMergeAsFolder      : ' + GravityAnimationConfig.getDelayOnMergeAsFolder() + ' \n';
        res += 'DelayOnAddToFolder        : ' + GravityAnimationConfig.getDelayOnAddToFolder() + ' \n';
        return res;
      }
    }, {
      cmdName: 'ShowCurveList',
      callback: (args: Array<string>) => {
        let res = 'Show all gravity animation curve list below: \n' + GravityAnimationConfig.getCurveList();
        return res;
      }
    }, {
      cmdName: 'Reset',
      callback: (args: Array<string>) => {
        let res = 'reset gravity animation config success \n';
        GravityAnimationConfig.reset();
        return res;
      }
    }, {
      cmdName: 'DrawLayout',
      callback: (args: Array<string>) => {
        let res = 'Show all components registered to gravity animation module below: \n' +
          gravityAnimationManager.drawLayouts();
        return res;
      }
    }, {
      cmdName: 'ShowComponent',
      callback: (args: Array<string>) => {
        let res = 'Show all components registered to gravity animation module below: \n' +
        gravityAnimationManager.showComponents();
        return res;
      }
    }, {
      cmdName: 'ShowSingle',
      callback: (args: Array<string>) => {
        return singleManager.toString();
      }
    })
    return cmds;
  }

  /* 注冊维测信息 */
  public static register(): void {
    if (!GravityAnimationDebug.isRegistered) {
      DebugCommandManager.getInstance().register('GravityAnimation', GravityAnimationDebug.getCommands());
      GravityAnimationDebug.isRegistered = true;
    }
  }
}