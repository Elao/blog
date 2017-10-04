---
type:           "post"
title:          "Planification de rendez-vous avec OptaPlanner"
date:           "2017-10-10"
publishdate:    "2017-10-10"
draft:          false
slug:           "planification-de-rdv-avec-optaplanner"
description:    ""

thumbnail:      "/images/posts/2017/planification-de-rdv-avec-optaplanner/optaplanner-teacher-agenda.png"
header_img:     "/images/posts/2017/planification-de-rdv-avec-optaplanner/optaplanner-logo.png"
tags:           [""]
categories:     ["dev"]

author_username: "rhanna"

---

## Le contexte

Notre client, Proximum Group avec sa plateforme [Vimeet](https://www.elao.com/fr/etudes-de-cas/vimeet/) propose à des
organisateurs d’événements une plateforme de gestion de rendez-vous B2B.

Avant l’événement les participants s’inscrivent sur la plateforme et consultent le catalogue des participants :

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/vimeet-catalogue.png" alt="Catalogue Vimeet" />
</p>

Les participants demandent en rendez-vous d'autres participanst, acceptent ou refusent des propositions de rendez-vous :

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/vimeet-gdr.png" alt="Catalogue Vimeet" />
</p>

Avant l’ouverture de l’événement l’agenda des rendez-vous de chaque participant est généré.
Toutes les demandes de rendez-vous acceptées ne sont pas satisfaits faute de disponibilité commune entre les
participants.

Un événement dure un à plusieurs jours durant lequel des professionnels vont se rencontrer en rdv.
La plateforme permet également de gérer d’autres types de rdv comme des recruteurs qui rencontrent des candidats
pendant une journée dédiée.

## La problématique

- Définition du besoin et Règles de positionnement rdv : priorité des types, lieu du rdv attribué à la fiche,
...Satisfaction : rdv > 70%, pour l’orga Max de rdv, lieu...

- Ce n'est pas un problème résolvable avec du Machine Learning ou de l'Intelligence Artificielle.

Il s'agit d'un [problème NP-complet](https://fr.wikipedia.org/wiki/Probl%C3%A8me_NP-complet) car le problème est
difficile à résoudre : pour avoir la solution idéale, il faudrait calculer toutes les combinaisons possibles.
Ce qui pourrait prendre des années voire une éternité.
En conséquence, il vaut mieux chercher des solutions approchées et acceptables en limitant le temps de calcul.

- Étude de  algo colonie de fourmi (schéma) et l’algorithme génétique

<p class="text-center">
    <img
        src="/images/posts/2017/planification-de-rdv-avec-optaplanner/algorithmes.png"
        alt="Algorithme génétique et algorithme de colonies de fourmis"
    />
</p>

- POC en PHP positionnement séquentiels des rdv puis évaluation de la solution -> trop lent

## Choix d'une solution Open Source, OptaPlanner

Solution Open Source [OptaPlanner](https://www.optaplanner.org/),
décrit comme un __solveur de satisfaction decontraintes__.
Sous licence Apache Software et chapoté par Red Hat, OptaPlanner est écrit en Java et Drools, un meta langage de règles
de gestion.

OptaPlanner est livré avec des exemples variés : 

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/optaplanner-examples.png" alt="Optaplanner exemples" />
</p>

Dont, l'optimisation de l'agenda des professeurs :

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/optaplanner-teacher-agenda.png" alt="Optimisation agenda de profs" />
</p>

L'affectation des lits d'un hôpital :

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/optaplanner-hospital.png" alt="Optimisation lits d'hôpital" />
</p>

La minimisation du trajet d'un voyageur de commerce :

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/optaplanner-traveller.png" alt="Optimisation trajet du voyageur de commerce" />
</p>

Et même l' optimisation du plan de tables d'un mariage :

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/optaplanner-wedding.png" alt="Optimisation du plan de table de mariage" />
</p>

- CH et LS. Auto. Tabu search ... algo utilisés
- Erreur : créer un nouveau cas from scratch, très compliqué
- Good idea : partir d’un exemple proche et l’adapter

### Modéliser le problème

Définir :

- Objectif
- Ressources
- Contraintes

et modéliser le problème :

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/model.png" alt="Modèle" />
</p>

### Les annotations de OptaPlanner

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/model-annotations.png" alt="Modèle" />
</p>

{{< highlight java >}}
import org.optaplanner.core.api.domain.solution.PlanningEntityCollectionProperty;
import org.optaplanner.core.api.domain.solution.PlanningScore;
import org.optaplanner.core.api.domain.solution.PlanningSolution;
import org.optaplanner.core.api.domain.solution.drools.ProblemFactCollectionProperty;
import org.optaplanner.core.api.domain.valuerange.ValueRangeProvider;

@PlanningSolution
public class MeetingSchedule {

    private List<Meeting> meetingList;
    private List<Slot> slotList;
    private List<Spot> spotList;
    private List<User> userList;
    private List<Sheet> sheetList;

    @PlanningEntityCollectionProperty
    public List<Meeting> getMeetingList() {
        return meetingList;
    }

    @ValueRangeProvider(id = "slotRange")
    @ProblemFactCollectionProperty
    public List<Slot> getSlotList() {
        return slotList;
    }

    @ValueRangeProvider(id = "spotRange")
    @ProblemFactCollectionProperty
    public List<Spot> getSpotList() {
        return spotList;
    }

    @ProblemFactCollectionProperty
    public List<User> getUserList() {
        return userList;
    }

    @ProblemFactCollectionProperty
    public List<Sheet> getSheetList() {
        return sheetList;
    }
{{< /highlight >}}


{{< highlight java >}}
import org.optaplanner.core.api.domain.entity.PlanningEntity;
import org.optaplanner.core.api.domain.variable.PlanningVariable;

@PlanningEntity()
public class Meeting {

    private List<Sheet> sheetList;
    private List<User> userList;

    private Slot slot = null;
    private Spot spot = null;

    @PlanningVariable(valueRangeProviderRefs = {"slotRange"}, nullable = true)
    public Slot getSlot() {
        return slot;
    }

    @PlanningVariable(valueRangeProviderRefs = {"spotRange"}, nullable = true)
    public Spot getSpot() {
        return spot;
    }
{{< /highlight >}}

### Les règles de gestion et les contraintes

#### Contrainte "Medium"

Il s'agit de l'objectif : ici on souhaite maximiser le nombre de rendez-vous positionnés lors d'un évènement.

{{< highlight java >}}
rule "Assign every meeting"
    when
        Meeting(isNotAssigned())
    then
        scoreHolder.addMediumConstraintMatch(kcontext, -1);
end
{{< /highlight >}}

#### Contrainte "Hard"

Ce sont des contraintes ne permettant pas de positionner un rendez-vous.

{{< highlight java >}}
rule "Unavailability conflict"
    when
        Meeting(hasUnavailabilityConflict())
    then
        scoreHolder.addHardConstraintMatch(kcontext, -10);
end
{{< /highlight >}}

Dans le modèle Meeting:

{{< highlight java >}}
@PlanningEntity()
public class Meeting {
    // ...
    
    public boolean hasUnavailabilityConflict() {
        if (null == slot) {
            return false;
        }

        for (User user : getUserList()) {
            List<Slot> unavailabilityList  = user.getUnavailabilityList();

            if (unavailabilityList != null) {
                for (Slot unavailability : unavailabilityList) {
                    if (slot == unavailability) {
                        return true;
                    }
                }
            }
        }

        return false;
    }
{{< /highlight >}}

Exemple un peu plus complexe d'une contrainte "Hard" qui empêche la création d'un rendez-vous lorsque la fiche de
participant a consommé tous ses crédits de rendez-vous :

{{< highlight java >}}
rule "Sheet do not have enought meetings quantity conflict"
    when
        $sheet : Sheet($possibleMeetingsQuantity : possibleMeetingsQuantity)
        accumulate(
            $meeting : Meeting(isAssigned(), sheetList contains $sheet);
            $totalMeetingBySheet : count($meeting);
            $totalMeetingBySheet > $possibleMeetingsQuantity
        )
    then
        scoreHolder.addHardConstraintMatch(kcontext, -1);
end
{{< /highlight >}}

#### Contrainte "Soft"

Ce sont les contraintes qui permettent d'optimiser la satisfaction des participants ou d'optimiser l'utilisation des
ressources.

{{< highlight java >}}
rule "Satisfaction : add -1 point penalty per 10% satisfaction = meetings assigned / possibleMeetingsQuantity"
    when
        $sheet : Sheet(possibleMeetingsQuantity > 0, $possibleMeetingsQuantity : possibleMeetingsQuantity)
        accumulate(
            $meeting : Meeting(isAssigned(), sheetList contains $sheet);
            $meetingCount : count($meeting)
        )
    then
        scoreHolder.addSoftConstraintMatch(kcontext, - (int) Math.ceil(10 - 10 * (float) $meetingCount / $possibleMeetingsQuantity));
end
{{< /highlight >}}

## Demo

Vsualisation de la génération des plannings pour tous les participants de l'évènement
- Spot : les lieux
- Sheet : les rendez-vous par fiche de participation (généralement équivalent à une fiche Société)
- User : les rendez-vous des participants

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/planner-real-event.gif" alt="Demo" />
</p>

Le participant a ensuite son agenda des rendez-vous accessible sur son ordinateur ou sur mobile :

<p class="text-center">
    <img
        src="/images/posts/2017/planification-de-rdv-avec-optaplanner/vimeet-agenda-mobile.png"
        alt="Agenda utilisateur"
    />
</p>

## Bilan

- Aujourd’hui : on a enlevé l’UI de l’app, c’est une app qu’on appelle en Cli runné par Jenkins. Les organisateurs d’évent cliquent sur un bouton depuis l’app vimeet et 30min plus tard ont leur rdv créés
- Bilan précédent / now

<p class="text-center">
    <img src="/images/posts/2017/planification-de-rdv-avec-optaplanner/stats-planifications.png" alt="Planifications" />
</p>

## Améliorations futures

- Améliorations possibles : rendre le solver plus rapide
- A la fois diluer les rdv d’un participant sur la journée mais aussi réduire les écarts entre rdv (pas de rdv en début et fin de journée)
- faire tourner la planification en continue quelques jours avant l’évènement et même pendant l’évènement pour positionner des rdvs et satisfaire encore plus les participants.

## Quand utiliser OptaPlanner ?

Lorsqu'un problème possède des objectifs, des règles de gestion et tout cela avec des ressources limitées,
c'est très probablement un problème de planification auquel OptaPlanner peut répondre.

