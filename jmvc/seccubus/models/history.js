/*
 * Copyright 2017 Frank Breedijk
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
steal('jquery/model', function(){

/**
 * @class Seccubus.Models.History
 * @parent History
 * @inherits jQuery.Model
 * Wraps backend history services.  
 */
$.Model('Seccubus.Models.History',
/* @Static */
{
	findAll: api("getFindingHistory.pl")
  	//findOne : "/histories/{id}.json", 
  	//create : "/histories.json",
 	//update : "/histories/{id}.json",
  	//destroy : "/histories/{id}.json"
},
/* @Prototype */
{});

})