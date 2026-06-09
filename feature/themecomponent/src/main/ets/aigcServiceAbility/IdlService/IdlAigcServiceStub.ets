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
import {resultStringCallback, operateResult, checkStateCallback} from './IIdlAigcService';
import IIdlAigcExtServiceCallback from './callback/IIdlAigcExtServiceCallback';
import IdlAigcExtServiceCallbackProxy from './callback/IdlAigcExtServiceCallbackProxy';
import IIdlAigcService from './IIdlAigcService';
import { Log } from './Log';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import rpc from '@ohos.rpc';

const TAG: string = '[AigcService]IdlAigcServiceStub';

export default class IdlAigcServiceStub extends rpc.RemoteObject implements IIdlAigcService {
  private static readonly MAX_STRING_COUNT = 20;
  private static readonly FAIL_CODE = -1;

  private readonly remoteMessageRequestMap: Map<number, Function> = new Map([
    [IdlAigcServiceStub.COMMAND_REQUEST_IMAGE,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleRequestImage(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_CHECK_STATE,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleCheckState(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_REGISTER,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleRegister(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_UNREGISTER,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleUnRegister(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_REMOVE_PATH_LIST,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleRemovePathList(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_CHECK_STATE_SYNC,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleCheckStateSync(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_START_PANDORA_NOTIFY,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleStartPandoraNotify(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_SET_FOLDED_CLIP_AREAS,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleSetFoldedClipAreas(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_ACTIVATE_AND_BEGIN_PANDORA,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleActivateAndBeginPandora(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_GENERATE_PICS,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleGeneratePictures(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_REMOVE_AIGC2_PATH_LIST,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleRemoveAIGC2PathList(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_ACTIVATE_AND_GENERATE_IMAGES,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleActivateAndGenerateImage(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_GENERATE_IMAGES,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleGenerateImages(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_START_GENERATE_PANDORA,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleStartGeneratePandora(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.COMMAND_ACTIVATE_AND_GENERATE_VIDEO,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleActivateAndGenerateVideo(data, reply);
        return true;
      }],
    [IdlAigcServiceStub.UPDATE_VIDEO,
      async (data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<boolean> => {
        await this.handleUpdateVideo(data, reply);
        return true;
      }],
  ]);

    constructor(des: string) {
        super(des);
    }

    private checkPermissionValid(): boolean {
        let callerTokenId = rpc.IPCSkeleton.getCallingTokenId();
        let accessManger = abilityAccessCtrl.createAtManager();
        let backgroundGrant = accessManger.verifyAccessTokenSync(callerTokenId,
            'ohos.permission.START_ABILITIES_FROM_BACKGROUND');
        let udidGrant = accessManger.verifyAccessTokenSync(callerTokenId, 'ohos.permission.sec.ACCESS_UDID');
        if (backgroundGrant === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED &&
            udidGrant === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
            Log.info(TAG, `PERMISSION_DENIED`);
            return false;
        }
        Log.info(TAG, 'checkPermissionValid success');
        return true;
    }

    async onRemoteMessageRequest(
        code: number, data:rpc.MessageSequence, reply:rpc.MessageSequence, option:rpc.MessageOption
    ): Promise<boolean> {
        if (this.getDescriptor() !== data.readInterfaceToken()) {
            Log.error(TAG, `onRemoteMessageRequest readInterfaceToken fail`);
            return false;
        }
        if (!this.checkPermissionValid()) {
            return false;
        }
        Log.info(TAG, 'onRemoteMessageRequest called, code = ' + code);
        if (this.remoteMessageRequestMap.has(code)) {
            try {
                return await this.remoteMessageRequestMap.get(code)?.(data, reply);
            } catch (err) {
                Log.error(TAG, `execute remote function fail.${code}`);
            }
        }
        return false;
    }

    private async handleRequestImage(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
        let themeIdVar = data.readString();
        let urlVar = data.readString();
        let uidVar = data.readString();
        let tokenVar = data.readString();
        let algParamVar = data.readString();
        let promise = new Promise<void>((resolve, reject) => {
            this.requestImage(themeIdVar, urlVar, uidVar, tokenVar, algParamVar, (errCode, returnValue) => {
                reply.writeInt(errCode);
                if (errCode === 0) {
                    reply.writeString(returnValue);
                }
                resolve();
            });
        });
        await promise;
    }

    private async handleCheckState(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
        let themeIdVar = data.readString();
        let promise = new Promise<void>((resolve, reject) => {
            this.checkState(themeIdVar, (errCode, returnValue) => {
                reply.writeInt(errCode);
                if (errCode === 0) {
                    reply.writeString(returnValue);
                }
                resolve();
            });
        });
        await promise;
    }

    private async handleRegister(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
        let key = data.readString();
        let cbVar = data.readRemoteObject();
        let promise = new Promise<void>((resolve, reject) => {
            this.register(key, new IdlAigcExtServiceCallbackProxy(cbVar), (errCode) => {
                reply.writeInt(errCode);
                resolve();
            });
        });
        await promise;
    }

    private async handleUnRegister(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
        let key = data.readString();
        let promise = new Promise<void>((resolve, reject) => {
            this.unRegister(key, (errCode) => {
                reply.writeInt(errCode);
                resolve();
            });
        });
        await promise;
    }

    private async handleRemovePathList(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
        let length: number = data.readInt();
        if (length > IdlAigcServiceStub.MAX_STRING_COUNT) {
            Log.error(TAG, `handleRemovePathList length error, length = ${length}`);
            reply.writeInt(-1);
            return;
        }
        let pathList: string[] = [];
        for (let i = 0; i < length; i++) {
            let key: string = data.readString();
            pathList.push(key);
        }
        let apply: boolean = data.readBoolean();
        let themeId: string = data.readString();
        let isEnableNotify: boolean = data.readBoolean();
        let promise = new Promise<void>((resolve, reject) => {
            this.removePathList(pathList, apply, themeId, isEnableNotify, (errCode) => {
                reply.writeInt(errCode);
                resolve();
            });
        });
        await promise;
    }

    private async handleCheckStateSync(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
        let themeIdVar = data.readString();
        let promise = new Promise<void>((resolve, reject) => {
            this.checkStateSync(themeIdVar, (result: number, statusCode: number, errCode: number) => {
                reply.writeInt(result);
                if (result === 0) {
                    reply.writeInt(statusCode);
                    reply.writeInt(errCode);
                }
                resolve();
            });
        });
        await promise;
    }

    private async handleStartPandoraNotify(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
        let themeId = data.readString();
        let notifyType = data.readInt();
        let errCode = data.readInt();
        let version = data.readString();
        let promise = new Promise<void>((resolve, reject) => {
          this.dealWithPandoraNotify(themeId, notifyType, errCode, (errCode) => {
            reply.writeInt(errCode);
            resolve();
          }, version);
        });
        await promise;
    }

    private async handleSetFoldedClipAreas(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
        let themeId: string = data.readString();
        let foldedClipAreas: string = data.readString();
        let promise = new Promise<void>((resolve, reject) => {
          this.setFoldedClipAreas(themeId, foldedClipAreas, (errCode) => {
            reply.writeInt(errCode);
            resolve();
          });
        });
        await promise;
    }

  private async handleActivateAndBeginPandora(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    let length: number = data.readInt();
    if (length > IdlAigcServiceStub.MAX_STRING_COUNT) {
      Log.error(TAG, `handleActivateAndBeginPandora length error, length = ${length}`);
      reply.writeInt(-1);
      return;
    }
    let paramList: string[] = [];
    for (let i = 0; i < length; i++) {
      let key: string = data.readString();
      paramList.push(key);
    }
    let version: string = data.readString();
    let promise = new Promise<void>((resolve, reject) => {
      this.activateAndBeginPandora(paramList, version, (errCode) => {
        reply.writeInt(errCode);
        resolve();
      });
    });
    await promise;
  }

  private async handleGeneratePictures(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    let themeIdVar = data.readString();
    let urlVar = data.readString();
    let promise = new Promise<void>((resolve, reject) => {
      this.generatePictures(themeIdVar, urlVar, (errCode, returnValue) => {
        reply.writeInt(errCode);
        if (errCode === 0) {
          reply.writeString(returnValue);
        }
        resolve();
      });
    });
    await promise;
  }


  private async handleRemoveAIGC2PathList(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    let length: number = data.readInt();
    if (length > IdlAigcServiceStub.MAX_STRING_COUNT) {
      Log.error(TAG, `handleRemovePathList length error, length = ${length}`);
      reply.writeInt(-1);
      return;
    }
    let pathList: string[] = [];
    for (let i = 0; i < length; i++) {
      let key: string = data.readString();
      pathList.push(key);
    }
    let apply: boolean = data.readBoolean();
    let themeId: string = data.readString();
    let isEnableNotify: boolean = data.readBoolean();
    let promise = new Promise<void>((resolve, reject) => {
      this.removeAIGC2PathList(pathList, apply, themeId, isEnableNotify, (errCode) => {
        reply.writeInt(errCode);
        resolve();
      });
    });
    await promise;
  }

  private async handleActivateAndGenerateImage(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    let length: number = data.readInt();
    if (length > IdlAigcServiceStub.MAX_STRING_COUNT) {
      Log.error(TAG, `handleActivateAndGenerateImage length error, length = ${length}`);
      reply.writeInt(-1);
      return;
    }
    let paramList: string[] = [];
    for (let i = 0; i < length; i++) {
      let key: string = data.readString();
      paramList.push(key);
    }
    let promise = new Promise<void>((resolve, reject) => {
      this.activateAndGenerateImages(paramList, (errCode) => {
        reply.writeInt(errCode);
        resolve();
      });
    });
    await promise;
  }

  private async handleGenerateImages(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    let themeIdVar = data.readString();
    let urlVar = data.readString();
    let algParamVar = data.readString();
    let promise = new Promise<void>((resolve, reject) => {
      this.generateImages(themeIdVar, urlVar, algParamVar, (errCode, returnValue) => {
        reply.writeInt(errCode);
        if (errCode === 0) {
          reply.writeString(returnValue);
        }
        resolve();
      });
    });
    await promise;
  }

  private async handleStartGeneratePandora(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    let length: number = data.readInt();
    if (length > IdlAigcServiceStub.MAX_STRING_COUNT) {
      Log.error(TAG, `handleStartGeneratePandora length error, length = ${length}`);
      reply.writeInt(-1);
      return;
    }
    let paramList: string[] = [];
    for (let i = 0; i < length; i++) {
      let key: string = data.readString();
      paramList.push(key);
    }
    let promise = new Promise<void>((resolve, reject) => {
      this.startGeneratePandora(paramList, (errCode, returnValue) => {
        reply.writeInt(errCode);
        if (errCode === 0) {
          reply.writeString(returnValue);
        }
        resolve();
      });
    });
    await promise;
  }

  private async handleActivateAndGenerateVideo(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    let length: number = data.readInt();
    if (length > IdlAigcServiceStub.MAX_STRING_COUNT) {
      Log.error(TAG, `handleActivateAndGenerateVideo length error, length = ${length}`);
      reply.writeInt(IdlAigcServiceStub.FAIL_CODE);
      return;
    }
    let paramList: string[] = [];
    for (let i = 0; i < length; i++) {
      let key: string = data.readString();
      paramList.push(key);
    }
    let promise = new Promise<void>((resolve, reject) => {
      this.activateAndGenerateVideo(paramList, (errCode, returnValue) => {
        reply.writeInt(errCode);
        if (errCode === 0) {
          reply.writeString(returnValue);
        }
        resolve();
      });
    });
    await promise;
  }

  private async handleUpdateVideo(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    let scenario: string = data.readString();
    let themeID: string = data.readString();
    let promise = new Promise<void>((resolve, reject) => {
      this.updateVideo(scenario, themeID);
      resolve();
    });
    await promise;
  }

  requestImage(themeId: string, url: string, uid: string, token: string, algParam: string,
    callback: resultStringCallback): void {
  }

  checkState(themeId: string, callback: resultStringCallback): void {
  }

  register(key: string, cb: IIdlAigcExtServiceCallback, callback: operateResult): void {
  }

  unRegister(key: string, callback: operateResult): void {
  }

  removePathList(toRemovePaths: string[], apply: boolean, themeId: string, isEnableNotify: boolean,
    callback: operateResult): void {
  }

  checkStateSync(themeId: string, callback: checkStateCallback): void {
  }

  dealWithPandoraNotify(themeId: string, notifyType: number, errCode: number, callback: operateResult,
    version: string): void {
  }

  setFoldedClipAreas(themeId: string, foldedClipAreas: string, callback: operateResult): void {
  }

  activateAndBeginPandora(paramList: string[], version: string, callback: operateResult): void {
  }

  generatePictures(themeId: string, url: string, callback: resultStringCallback): void {
  }

  removeAIGC2PathList(toRemovePaths: string[], apply: boolean, themeId: string, isEnableNotify: boolean,
    callback: operateResult): void {
  }

  activateAndGenerateImages(paramList: string[], callback: operateResult): void {
  }

  generateImages(themeID: string, url: string, algParam: string, callback: resultStringCallback): void {
  }

  startGeneratePandora(paramList: string[], callback: resultStringCallback): void {
  }

  activateAndGenerateVideo(paramList: string[], callback: resultStringCallback): void {
  }

  updateVideo(scenario: string, themeID: string): void {
  }

  public static readonly COMMAND_REQUEST_IMAGE = 1;
  public static readonly COMMAND_CHECK_STATE = 2;
  public static readonly COMMAND_REGISTER = 3;
  public static readonly COMMAND_UNREGISTER = 4;
  public static readonly COMMAND_REMOVE_PATH_LIST = 5;
  public static readonly COMMAND_CHECK_STATE_SYNC = 6;
  public static readonly COMMAND_START_PANDORA_NOTIFY = 7;
  public static readonly COMMAND_SET_FOLDED_CLIP_AREAS = 8;
  public static readonly COMMAND_ACTIVATE_AND_BEGIN_PANDORA = 9;
  public static readonly COMMAND_GENERATE_PICS = 10;
  public static readonly COMMAND_REMOVE_AIGC2_PATH_LIST = 11;
  public static readonly COMMAND_ACTIVATE_AND_GENERATE_IMAGES = 12;
  public static readonly COMMAND_GENERATE_IMAGES = 13;
  public static readonly COMMAND_START_GENERATE_PANDORA = 14;
  public static readonly COMMAND_ACTIVATE_AND_GENERATE_VIDEO = 15;
  public static readonly UPDATE_VIDEO = 301;
}

